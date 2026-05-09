import 'package:flutter/material.dart';
import 'package:space_app/models/space_object.dart';

class ObjectCard extends StatelessWidget {
  final SpaceObject spaceobject;
  const ObjectCard({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[800],
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Text(
              spaceobject.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: Text(
              spaceobject.category,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: Text(
              spaceobject.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
