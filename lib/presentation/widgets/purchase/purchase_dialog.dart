import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../../data/models/product_model.dart';
import '../../../data/models/supplier_model.dart';
import '../../../data/repositories/product_service.dart';
import '../../../data/repositories/purchase_service.dart';
import '../../../data/repositories/supplier_service.dart';

class PurchaseDialog extends StatefulWidget {

  const PurchaseDialog({super.key});

  @override
  State<PurchaseDialog> createState() =>
      _PurchaseDialogState();
}

class _PurchaseDialogState
    extends State<PurchaseDialog> {

  final PurchaseService purchaseService =
  PurchaseService();

  final SupplierService supplierService =
  SupplierService();

  final ProductService productService =
  ProductService();

  bool loading = true;

  List<SupplierModel> suppliers = [];

  List<ProductModel> products = [];

  SupplierModel? selectedSupplier;

  String paymentTerms = "7 Days";

  final List<Map<String, dynamic>> items = [];

  double totalAmount = 0;

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    try {

      final supplierData =
      await supplierService.getAllSuppliers();

      final productData =
      await productService.getProducts();

      setState(() {

        suppliers = supplierData;

        products = productData;

        loading = false;
      });

      addItem();

    } catch(e){

      setState(() => loading = false);

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to load data",
        );
      }
    }
  }

  void addItem(){

    items.add({

      "product": null,
      "quantity": 1,
      "unit": "Pcs",
      "unitPrice": 0.0,
    });

    setState(() {});
  }

  void removeItem(int index){

    items.removeAt(index);

    calculateTotal();
  }

  void calculateTotal(){

    double total = 0;

    for(final item in items){

      total +=
          (item["quantity"] ?? 0) *
              (item["unitPrice"] ?? 0);
    }

    setState(() {
      totalAmount = total;
    });
  }

  Future<void> createPurchase() async {

    if(selectedSupplier == null){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Select supplier",
      );

      return;
    }

    if(items.isEmpty){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Add at least one product",
      );

      return;
    }

    for(final item in items){

      if(item["product"] == null){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: "Select all products",
        );

        return;
      }
    }

    final body = {

      "supplierId": selectedSupplier!.id,

      "paymentTerms": paymentTerms,

      "status": "PENDING",

      "totalAmount": totalAmount,

      "items": items.map((e){

        return {

          "productId":
          (e["product"] as ProductModel).id,

          "quantity": e["quantity"],

          "unit": e["unit"],

          "unitPrice": e["unitPrice"],
        };

      }).toList(),
    };

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: "Creating Purchase...",
    );

    try {

      final success =
      await purchaseService.createPurchase(body);

      if(mounted){

        Navigator.pop(context);

        if(success){

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Purchase Created",
          );

          Navigator.pop(context, true);

        } else {

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Creation failed",
          );
        }
      }

    } catch(e){

      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Something went wrong",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Container(

        width: 900,

        padding: const EdgeInsets.all(20),

        child: loading

            ? const SizedBox(

          height: 300,

          child: Center(
            child: CircularProgressIndicator(),
          ),
        )

            : SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(

                "Create Purchase",

                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<SupplierModel>(

                value: selectedSupplier,

                decoration: InputDecoration(

                  labelText: "Supplier",

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                items: suppliers.map((s){

                  return DropdownMenuItem(

                    value: s,

                    child: Text(s.name),
                  );

                }).toList(),

                onChanged: (v){

                  setState(() {
                    selectedSupplier = v;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(

                value: paymentTerms,

                decoration: InputDecoration(

                  labelText: "Payment Terms",

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                items: [

                  "7 Days",
                  "15 Days",
                  "30 Days",

                ].map((e){

                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );

                }).toList(),

                onChanged: (v){

                  setState(() {
                    paymentTerms = v!;
                  });
                },
              ),

              const SizedBox(height: 24),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    "Items",

                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ElevatedButton.icon(

                    onPressed: addItem,

                    icon: const Icon(Icons.add),

                    label: const Text("Add Product"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ...List.generate(items.length, (index){

                final item = items[index];

                return Container(

                  margin:
                  const EdgeInsets.only(bottom: 16),

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),

                    borderRadius:
                    BorderRadius.circular(16),
                  ),

                  child: Column(

                    children: [

                      DropdownButtonFormField<ProductModel>(

                        value: item["product"],

                        decoration: InputDecoration(

                          labelText: "Product",

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),

                        items: products.map((p){

                          return DropdownMenuItem(

                            value: p,

                            child: Text(p.name),
                          );

                        }).toList(),

                        onChanged: (v){

                          setState(() {
                            item["product"] = v;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(

                        children: [

                          Expanded(

                            child: TextFormField(

                              initialValue:
                              item["quantity"]
                                  .toString(),

                              keyboardType:
                              TextInputType.number,

                              decoration: InputDecoration(

                                labelText: "Qty",

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                ),
                              ),

                              onChanged: (v){

                                item["quantity"] =
                                    int.tryParse(v) ?? 1;

                                calculateTotal();
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(

                            child:
                            DropdownButtonFormField<String>(

                              value: item["unit"],

                              decoration: InputDecoration(

                                labelText: "Unit",

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                ),
                              ),

                              items: [

                                "Pcs",
                                "Kg",
                                "Box",

                              ].map((e){

                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );

                              }).toList(),

                              onChanged: (v){

                                item["unit"] = v;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(

                        children: [

                          Expanded(

                            child: TextFormField(

                              initialValue:
                              item["unitPrice"]
                                  .toString(),

                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),

                              decoration: InputDecoration(

                                labelText: "Unit Price",

                                prefixText: "৳ ",

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                ),
                              ),

                              onChanged: (v){

                                item["unitPrice"] =
                                    double.tryParse(v)
                                        ?? 0;

                                calculateTotal();
                              },
                            ),
                          ),

                          IconButton(

                            onPressed: (){
                              removeItem(index);
                            },

                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Align(

                        alignment:
                        Alignment.centerRight,

                        child: Text(

                          "Subtotal: ৳ ${((item["quantity"] ?? 0) * (item["unitPrice"] ?? 0)).toStringAsFixed(2)}",

                          style: GoogleFonts.inter(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 10),

              Align(

                alignment: Alignment.centerRight,

                child: Text(

                  "Total: ৳ ${totalAmount.toStringAsFixed(2)}",

                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: createPurchase,

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(0xFF6366F1),

                    foregroundColor: Colors.white,

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    "Create Purchase",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}