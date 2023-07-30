import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/controller/cart_notifier.dart';
import 'package:sneaker_app/models/product_data.dart';
import 'package:sneaker_app/service/firestore_service.dart';
import 'package:sneaker_app/ui/view/product_detail_page.dart';

import '../../../models/cart_data.dart';
import '../text_style.dart';

class ItemOfCart extends StatefulWidget {
  const ItemOfCart({
    super.key,
    required this.item,
    required this.id,
  });

  final CartData item;
  final String id;

  @override
  State<ItemOfCart> createState() => _ItemOfCartState();
}

class _ItemOfCartState extends State<ItemOfCart> {
  @override
  void initState() {
    if (widget.item.isSelected == true) {
      FirestoreService().updateCheckedItemOfCart(widget.id, false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int amount = widget.item.price * widget.item.quantity;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.all(8),
              borderRadius: BorderRadius.all(Radius.circular(16)),
              onPressed: (context) {
                if (widget.item.isSelected == true) {
                  Provider.of<CartNotifier>(context, listen: false)
                      .total(amount, false);
                }
                FirestoreService().deleteItem(widget.id);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            ProductData? product =
                FirestoreService().getProduct(widget.item.idProduct);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                  idProduct: widget.id,
                ),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(4, 8),
                )
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: widget.item.isSelected,
                  onChanged: (checked) {
                    FirestoreService()
                        .updateCheckedItemOfCart(widget.id, checked!);
                    Provider.of<CartNotifier>(context, listen: false)
                        .total(amount, checked);
                  },
                ),
                CachedNetworkImage(
                  imageUrl: widget.item.image,
                  height: 120,
                  width: 120,
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.item.name}',
                        overflow: TextOverflow.ellipsis,
                        style: textStyleApp(
                          FontWeight.w700,
                          Colors.black,
                          18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Size: ${widget.item.size}',
                        style: textStyleApp(
                          FontWeight.normal,
                          Colors.black,
                          18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Số lượng: ${widget.item.quantity}',
                        style: textStyleApp(
                          FontWeight.w500,
                          Colors.black,
                          18,
                        ),
                      ),
                      Text(
                        'Giá: ${widget.item.price}.000₫',
                        style: textStyleApp(
                          FontWeight.w500,
                          Colors.black,
                          18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
