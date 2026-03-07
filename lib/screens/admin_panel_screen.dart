import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _db = FirebaseFirestore.instance;

// ─── Main Screen ─────────────────────────────────────────────────────────────

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Content Manager'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.person_outline), text: 'Pandits'),
              Tab(icon: Icon(Icons.temple_hindu_outlined), text: 'Packages'),
              Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'Products'),
              Tab(icon: Icon(Icons.schedule_outlined), text: 'Slots'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PanditsTab(),
            _PackagesTab(),
            _ProductsTab(),
            _SlotsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

Future<void> _deleteDoc(
  BuildContext context,
  String collection,
  String docId,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirm == true) {
    await _db.collection(collection).doc(docId).delete();
  }
}

Widget _chip(String label) => Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

// Reusable labeled text field for forms
Widget _formField(
  TextEditingController controller,
  String label, {
  int maxLines = 1,
  String? hint,
  TextInputType? keyboard,
  bool required = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
    ),
  );
}

Widget _saveButton(bool saving, VoidCallback onSave) => ElevatedButton(
      onPressed: saving ? null : onSave,
      child: saving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Save'),
    );

// ─── Pandits Tab ──────────────────────────────────────────────────────────────

class _PanditsTab extends StatelessWidget {
  const _PanditsTab();

  void _openForm(BuildContext context, [String? docId, Map<String, dynamic>? data]) {
    showDialog(
      context: context,
      builder: (_) => _PanditFormDialog(docId: docId, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('pandit_profiles')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('No pandits yet', style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final name =
                  (data['name'] as String?)?.isNotEmpty == true
                      ? data['name'] as String
                      : doc.id;
              final bio = (data['bio'] as String?) ?? '';
              final isVerified = data['isVerified'] == true;
              final experience = data['experience'] ?? 0;
              final location = (data['location'] as String?) ?? '';
              final specialities =
                  List<String>.from(data['specialities'] ?? []);
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isVerified ? Colors.green[100] : Colors.orange[100],
                    child: Icon(
                      isVerified ? Icons.verified : Icons.pending_outlined,
                      color: isVerified ? Colors.green : Colors.orange,
                      size: 22,
                    ),
                  ),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (bio.isNotEmpty)
                        Text(bio,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12)),
                      Text('$experience yrs  •  $location',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      if (specialities.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            children:
                                specialities.take(3).map(_chip).toList(),
                          ),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openForm(context, doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () =>
                          _deleteDoc(context, 'pandit_profiles', doc.id),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Pandit'),
      ),
    );
  }
}

class _PanditFormDialog extends StatefulWidget {
  const _PanditFormDialog({this.docId, this.data});
  final String? docId;
  final Map<String, dynamic>? data;

  @override
  State<_PanditFormDialog> createState() => _PanditFormDialogState();
}

class _PanditFormDialogState extends State<_PanditFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _bio, _specialities,
      _languages, _location, _experience, _rating;
  bool _isVerified = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.data ?? {};
    _name = TextEditingController(text: (d['name'] as String?) ?? '');
    _bio = TextEditingController(text: (d['bio'] as String?) ?? '');
    _specialities = TextEditingController(
        text: (d['specialities'] as List?)?.join(', ') ?? '');
    _languages = TextEditingController(
        text: (d['languages'] as List?)?.join(', ') ?? '');
    _location = TextEditingController(text: (d['location'] as String?) ?? '');
    _experience =
        TextEditingController(text: '${d['experience'] ?? 0}');
    _rating = TextEditingController(
        text: (d['rating'] as num?)?.toStringAsFixed(1) ?? '0.0');
    _isVerified = d['isVerified'] == true;
  }

  @override
  void dispose() {
    for (final c in [
      _name, _bio, _specialities, _languages,
      _location, _experience, _rating,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      List<String> split(String raw) => raw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final payload = <String, dynamic>{
        'name': _name.text.trim(),
        'bio': _bio.text.trim(),
        'specialities': split(_specialities.text),
        'languages': split(_languages.text),
        'location': _location.text.trim(),
        'experience': int.tryParse(_experience.text.trim()) ?? 0,
        'rating': double.tryParse(_rating.text.trim()) ?? 0.0,
        'isVerified': _isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId != null) {
        await _db
            .collection('pandit_profiles')
            .doc(widget.docId)
            .update(payload);
      } else {
        payload['createdAt'] = FieldValue.serverTimestamp();
        final ref = _db.collection('pandit_profiles').doc();
        payload['id'] = ref.id;
        await ref.set(payload);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.docId == null ? 'Add Pandit' : 'Edit Pandit'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _formField(_name, 'Name', required: true),
              _formField(_bio, 'Bio', maxLines: 3, required: true),
              _formField(
                _specialities,
                'Specialities',
                hint: 'e.g. Vivah Puja, Griha Pravesh',
              ),
              _formField(
                _languages,
                'Languages',
                hint: 'e.g. Hindi, Sanskrit, English',
              ),
              _formField(_location, 'Location', required: true),
              _formField(
                _experience,
                'Experience (years)',
                keyboard: TextInputType.number,
              ),
              _formField(
                _rating,
                'Rating (0.0 – 5.0)',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
              SwitchListTile(
                title: const Text('Verified'),
                dense: true,
                value: _isVerified,
                onChanged: (v) => setState(() => _isVerified = v),
                contentPadding: EdgeInsets.zero,
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        _saveButton(_saving, _save),
      ],
    );
  }
}

// ─── Packages Tab ─────────────────────────────────────────────────────────────

class _PackagesTab extends StatelessWidget {
  const _PackagesTab();

  void _openForm(BuildContext context,
      [String? docId, Map<String, dynamic>? data]) {
    showDialog(
      context: context,
      builder: (_) => _PackageFormDialog(docId: docId, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('pooja_packages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.temple_hindu_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('No packages yet',
                    style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final name = (data['name'] as String?) ?? 'Unnamed';
              final price =
                  (data['price'] as num?)?.toDouble() ?? 0.0;
              final duration = data['durationInMinutes'] ?? 0;
              final isFeatured = data['isFeatured'] == true;
              final langs =
                  List<String>.from(data['languages'] ?? []);
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isFeatured
                        ? Colors.amber[100]
                        : Colors.deepOrange[50],
                    child: Icon(
                      isFeatured ? Icons.star : Icons.temple_hindu_outlined,
                      color: isFeatured
                          ? Colors.amber[700]
                          : Colors.deepOrange,
                      size: 22,
                    ),
                  ),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹${price.toStringAsFixed(0)}  •  $duration min',
                          style: const TextStyle(fontSize: 12)),
                      if (langs.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                              children: langs.take(3).map(_chip).toList()),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openForm(context, doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () =>
                          _deleteDoc(context, 'pooja_packages', doc.id),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Package'),
      ),
    );
  }
}

class _PackageFormDialog extends StatefulWidget {
  const _PackageFormDialog({this.docId, this.data});
  final String? docId;
  final Map<String, dynamic>? data;

  @override
  State<_PackageFormDialog> createState() => _PackageFormDialogState();
}

class _PackageFormDialogState extends State<_PackageFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _description, _price,
      _duration, _languages, _imageUrl;
  bool _isFeatured = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.data ?? {};
    _name = TextEditingController(text: (d['name'] as String?) ?? '');
    _description =
        TextEditingController(text: (d['description'] as String?) ?? '');
    _price = TextEditingController(
        text: (d['price'] as num?)?.toStringAsFixed(0) ?? '');
    _duration = TextEditingController(
        text: '${d['durationInMinutes'] ?? ''}');
    _languages = TextEditingController(
        text: (d['languages'] as List?)?.join(', ') ?? '');
    _imageUrl =
        TextEditingController(text: (d['imageUrl'] as String?) ?? '');
    _isFeatured = d['isFeatured'] == true;
  }

  @override
  void dispose() {
    for (final c in [
      _name, _description, _price, _duration, _languages, _imageUrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final langs = _languages.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final payload = <String, dynamic>{
        'name': _name.text.trim(),
        'description': _description.text.trim(),
        'price': double.tryParse(_price.text.trim()) ?? 0.0,
        'durationInMinutes': int.tryParse(_duration.text.trim()) ?? 60,
        'languages': langs,
        'imageUrl': _imageUrl.text.trim(),
        'isFeatured': _isFeatured,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId != null) {
        await _db
            .collection('pooja_packages')
            .doc(widget.docId)
            .update(payload);
      } else {
        payload['createdAt'] = FieldValue.serverTimestamp();
        final ref = _db.collection('pooja_packages').doc();
        payload['id'] = ref.id;
        await ref.set(payload);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.docId == null ? 'Add Pooja Package' : 'Edit Pooja Package'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _formField(_name, 'Package Name', required: true),
              _formField(_description, 'Description',
                  maxLines: 3, required: true),
              _formField(_price, 'Price (₹)',
                  keyboard: TextInputType.number, required: true),
              _formField(_duration, 'Duration (minutes)',
                  keyboard: TextInputType.number, required: true),
              _formField(_languages, 'Languages',
                  hint: 'e.g. Hindi, Sanskrit, Tamil'),
              _formField(_imageUrl, 'Image URL'),
              SwitchListTile(
                title: const Text('Featured'),
                dense: true,
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
                contentPadding: EdgeInsets.zero,
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        _saveButton(_saving, _save),
      ],
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  void _openForm(BuildContext context,
      [String? docId, Map<String, dynamic>? data]) {
    showDialog(
      context: context,
      builder: (_) => _ProductFormDialog(docId: docId, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('shop_products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('No products yet',
                    style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final name = (data['name'] as String?) ?? 'Unnamed';
              final price =
                  (data['price'] as num?)?.toDouble() ?? 0.0;
              final stock = (data['stock'] as int?) ?? 0;
              final inStock = stock > 0;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        inStock ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: inStock ? Colors.green : Colors.red,
                      size: 22,
                    ),
                  ),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '₹${price.toStringAsFixed(0)}  •  Stock: $stock',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openForm(context, doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () =>
                          _deleteDoc(context, 'shop_products', doc.id),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({this.docId, this.data});
  final String? docId;
  final Map<String, dynamic>? data;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _description, _price,
      _imageUrl, _stock;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.data ?? {};
    _name = TextEditingController(text: (d['name'] as String?) ?? '');
    _description =
        TextEditingController(text: (d['description'] as String?) ?? '');
    _price = TextEditingController(
        text: (d['price'] as num?)?.toStringAsFixed(0) ?? '');
    _imageUrl =
        TextEditingController(text: (d['imageUrl'] as String?) ?? '');
    _stock =
        TextEditingController(text: '${(d['stock'] as int?) ?? 0}');
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _price, _imageUrl, _stock]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'name': _name.text.trim(),
        'description': _description.text.trim(),
        'price': double.tryParse(_price.text.trim()) ?? 0.0,
        'imageUrl': _imageUrl.text.trim(),
        'stock': int.tryParse(_stock.text.trim()) ?? 0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId != null) {
        await _db
            .collection('shop_products')
            .doc(widget.docId)
            .update(payload);
      } else {
        payload['createdAt'] = FieldValue.serverTimestamp();
        final ref = _db.collection('shop_products').doc();
        payload['id'] = ref.id;
        await ref.set(payload);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.docId == null ? 'Add Shop Product' : 'Edit Shop Product'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _formField(_name, 'Product Name', required: true),
              _formField(_description, 'Description',
                  maxLines: 3, required: true),
              _formField(_price, 'Price (₹)',
                  keyboard: TextInputType.number, required: true),
              _formField(_stock, 'Stock Quantity',
                  keyboard: TextInputType.number, required: true),
              _formField(_imageUrl, 'Image URL'),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        _saveButton(_saving, _save),
      ],
    );
  }
}

// ─── Consultation Slots Tab ───────────────────────────────────────────────────

class _SlotsTab extends StatelessWidget {
  const _SlotsTab();

  void _openForm(BuildContext context,
      [String? docId, Map<String, dynamic>? data]) {
    showDialog(
      context: context,
      builder: (_) => _SlotFormDialog(docId: docId, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('consultation_slots')
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_month_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('No consultation slots yet',
                    style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final panditName =
                  (data['panditName'] as String?) ?? 'Unknown Pandit';
              final price =
                  (data['price'] as num?)?.toDouble() ?? 0.0;
              final duration =
                  (data['durationMinutes'] as int?) ?? 60;
              final isAvailable = data['isAvailable'] == true;

              DateTime? slotDate;
              final rawDate = data['date']?.toString() ?? '';
              if (rawDate.isNotEmpty) {
                try {
                  slotDate = DateTime.parse(rawDate).toLocal();
                } catch (_) {}
              }

              final dateLabel = slotDate != null
                  ? '${slotDate.day}/${slotDate.month}/${slotDate.year}'
                      '  ${slotDate.hour.toString().padLeft(2, '0')}'
                      ':${slotDate.minute.toString().padLeft(2, '0')}'
                  : 'No date';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isAvailable ? Colors.blue[100] : Colors.grey[200],
                    child: Icon(
                      isAvailable
                          ? Icons.event_available
                          : Icons.event_busy,
                      color:
                          isAvailable ? Colors.blue : Colors.grey,
                      size: 22,
                    ),
                  ),
                  title: Text(panditName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '$dateLabel  •  $duration min  •  ₹${price.toStringAsFixed(0)}\n'
                    '${isAvailable ? 'Available' : 'Booked/Unavailable'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openForm(context, doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _deleteDoc(
                          context, 'consultation_slots', doc.id),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Slot'),
      ),
    );
  }
}

class _SlotFormDialog extends StatefulWidget {
  const _SlotFormDialog({this.docId, this.data});
  final String? docId;
  final Map<String, dynamic>? data;

  @override
  State<_SlotFormDialog> createState() => _SlotFormDialogState();
}

class _SlotFormDialogState extends State<_SlotFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _panditId, _panditName, _price;
  int _duration = 60;
  bool _isAvailable = true;
  bool _saving = false;
  DateTime _selectedDate =
      DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    final d = widget.data ?? {};
    _panditId =
        TextEditingController(text: (d['panditId'] as String?) ?? '');
    _panditName =
        TextEditingController(text: (d['panditName'] as String?) ?? '');
    _price = TextEditingController(
        text: (d['price'] as num?)?.toStringAsFixed(0) ?? '');
    _duration = (d['durationMinutes'] as int?) ?? 60;
    _isAvailable = (d['isAvailable'] as bool?) ?? true;

    final rawDate = d['date']?.toString() ?? '';
    if (rawDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawDate).toLocal();
        _selectedDate = dt;
        _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _panditId.dispose();
    _panditName.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final slotDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final endDateTime =
          slotDateTime.add(Duration(minutes: _duration));

      final payload = <String, dynamic>{
        'panditId': _panditId.text.trim(),
        'panditName': _panditName.text.trim(),
        'date': slotDateTime.toIso8601String(),
        'endDate': endDateTime.toIso8601String(),
        'durationMinutes': _duration,
        'price': double.tryParse(_price.text.trim()) ?? 0.0,
        'isAvailable': _isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId != null) {
        await _db
            .collection('consultation_slots')
            .doc(widget.docId)
            .update(payload);
      } else {
        payload['createdAt'] = FieldValue.serverTimestamp();
        final ref = _db.collection('consultation_slots').doc();
        payload['id'] = ref.id;
        await ref.set(payload);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    final timeLabel = _selectedTime.format(context);

    return AlertDialog(
      title: Text(widget.docId == null
          ? 'Add Consultation Slot'
          : 'Edit Consultation Slot'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _formField(_panditName, 'Pandit Name', required: true),
              _formField(_panditId, 'Pandit Profile UID',
                  hint: 'From pandit_profiles collection'),
              _formField(
                _price,
                'Price (₹)',
                keyboard: TextInputType.number,
                required: true,
              ),
              const SizedBox(height: 4),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(dateLabel),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time, size: 16),
                    label: Text(timeLabel),
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                initialValue: _duration,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 45, child: Text('45 minutes')),
                  DropdownMenuItem(value: 60, child: Text('60 minutes')),
                  DropdownMenuItem(value: 90, child: Text('90 minutes')),
                ],
                onChanged: (v) => setState(() => _duration = v ?? 60),
              ),
              SwitchListTile(
                title: const Text('Available for Booking'),
                dense: true,
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
                contentPadding: EdgeInsets.zero,
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        _saveButton(_saving, _save),
      ],
    );
  }
}
