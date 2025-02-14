import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatStatusRow extends ConsumerWidget {
  const ChatStatusRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF4B9289),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            // scale: 52,
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF24786D),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child:
                          Icon(Icons.add, size: 10, color: Color(0xFF24786D)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'My Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.caros,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF4B9289),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            // scale: 52,
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.caros,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
