import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_card.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../../data/models/purchase_model.dart';
import '../../../data/repositories/purchase_service.dart';

class PurchaseScreen extends StatefulWidget {

  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() =>
      _PurchaseScreenState();
}

class _PurchaseScreenState
    extends State<PurchaseScreen> {

  final PurchaseService service =
  PurchaseService();

  List<PurchaseOrderModel> orders = [];

  List<PurchaseOrderModel> filtered = [];

  bool loading = true;

  final searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {

    setState(() => loading = true);

    try{

      final data =
      await service.getAllOrders();

      setState(() {

        orders = data;

        filtered = data;

        loading = false;
      });

    }catch(e){

      setState(() => loading = false);
    }
  }

  void search(String value){

    setState(() {

      filtered = orders.where((e){

        return e.invoiceNumber
            .toLowerCase()
            .contains(value.toLowerCase())

            ||

            (e.supplier?.name ?? "")
                .toLowerCase()
                .contains(value.toLowerCase());

      }).toList();
    });
  }

  Future<void> updateStatus(
      PurchaseOrderModel order,
      String status,
      ) async {

    final success =
    await service.updateStatus(
      order.id!,
      status,
    );

    if(success){

      if(status == "RECEIVED"){

        await service.sendMail(order.id!);
      }

      loadOrders();

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Updated",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF8FAFC),

      body: Column(

        children: [

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),

            color: Colors.white,

            child: Row(

              children: [

                Expanded(

                  flex: 3,

                  child: TextField(

                    controller: searchController,

                    onChanged: search,

                    decoration: InputDecoration(

                      hintText: "Search purchase...",

                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6366F1),
                      ),

                      filled: true,

                      fillColor: const Color(0xFFF1F5F9),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(

                  flex: 1,

                  child: ElevatedButton.icon(

                    onPressed: () async {

                      final result =
                      await showDialog(

                        context: context,

                        builder: (_) =>
                        const PurchaseDialog(),
                      );

                      if(result == true){

                        loadOrders();
                      }
                    },

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(0xFF6366F1),

                      foregroundColor:
                      Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    icon: const Icon(Icons.add),

                    label: Text(
                      "New Purchase",

                      style: GoogleFonts.inter(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(

            child: loading

                ? const Center(
              child:
              CircularProgressIndicator(),
            )

                : ListView.builder(

              padding:
              const EdgeInsets.all(16),

              itemCount: filtered.length,

              itemBuilder: (context,index){

                final order =
                filtered[index];

                return PurchaseCard(

                  order: order,

                  onView: (){

                    showDialog(

                      context: context,

                      builder: (_) =>
                          PurchaseDetailsDialog(
                            order,
                          ),
                    );
                  },

                  onApprove: (){

                    updateStatus(
                      order,
                      "APPROVED",
                    );
                  },

                  onReceive: (){

                    updateStatus(
                      order,
                      "RECEIVED",
                    );
                  },

                  onCancel: (){

                    updateStatus(
                      order,
                      "CANCELLED",
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}