import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final documents = [
      {'title': 'Employment_Contract_SH.pdf', 'type': 'PDF', 'category': 'Contracts', 'date': 'Apr 12, 2026'},
      {'title': 'National_ID_Salman.jpg', 'type': 'Image', 'category': 'ID Proofs', 'date': 'Apr 12, 2026'},
      {'title': 'Training_Certificate_Flutter.pdf', 'type': 'PDF', 'category': 'Certs', 'date': 'May 01, 2026'},
      {'title': 'Salary_Agreement_2026.pdf', 'type': 'PDF', 'category': 'Financials', 'date': 'Jan 15, 2026'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Document Vault', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Securely store and manage employee records', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              if (isDesktop)
                CustomButton(
                  text: 'Upload New Document',
                  icon: Icons.upload_outlined,
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Folders
          const Text('Root Directories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _FolderCard(name: 'Employee Contracts', count: '12', icon: Icons.folder_shared_outlined, color: Colors.blue),
              _FolderCard(name: 'Identity Proofs', count: '45', icon: Icons.folder_special_outlined, color: Colors.orange),
              _FolderCard(name: 'Policy Documents', count: '08', icon: Icons.folder_zip_outlined, color: Colors.purple),
              _FolderCard(name: 'Certifications', count: '22', icon: Icons.folder_copy_outlined, color: Colors.green),
            ],
          ),
          const SizedBox(height: 32),

          // File List
          const Text('Recent Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final doc = documents[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      doc['type'] == 'PDF' ? Icons.description_outlined : Icons.image_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(doc['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${doc['category']} • Uploaded on ${doc['date']}', style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => AppToast.showInfo(context, 'Downloading File...'), icon: const Icon(Icons.download_rounded, size: 20)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, size: 20)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String name;
  final String count;
  final IconData icon;
  final Color color;

  const _FolderCard({required this.name, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('$count Files', style: TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
