import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/wealth_item.dart';

class AccountManagementScreen extends ConsumerStatefulWidget {
  final WealthItem account;

  const AccountManagementScreen({
    super.key,
    required this.account,
  });

  @override
  ConsumerState<AccountManagementScreen> createState() => _AccountManagementScreenState();
}

class _AccountManagementScreenState extends ConsumerState<AccountManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _identifierController;
  late TextEditingController _balanceController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _identifierController = TextEditingController(text: widget.account.identifier ?? '');
    _balanceController = TextEditingController(text: widget.account.value.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArchived = widget.account.status == WealthItemStatus.archived;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          widget.account.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider & Identifier display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(widget.account.iconData, color: AppColors.textPrimary, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    widget.account.institution ?? 'Unknown Provider',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (widget.account.identifier != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.account.identifier!.length > 4 
                          ? '••••${widget.account.identifier!.substring(widget.account.identifier!.length - 4)}'
                          : widget.account.identifier!,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Edit Fields
            const Text(
              'Account Name',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Account name is required';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.negative, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.negative, width: 1),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (widget.account.category.toUpperCase() != 'CASH') ...[
              const Text(
                'Account Number / ID',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _identifierController,
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Must be numeric';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.negative, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.negative, width: 1),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
            
            const Text(
              'Current Balance (Rp)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Current balance is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Must be a valid number';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.negative, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.negative, width: 1),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Actions
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.surfaceHover,
                      title: const Text('Save Changes?', style: TextStyle(color: AppColors.textPrimary)),
                      content: const Text('Are you sure you want to update this account?', style: TextStyle(color: AppColors.textSecondary)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            SuccessAlertDialog.show(
                              context,
                              title: 'Account Updated',
                              message: 'Account details have been successfully updated.',
                              onOkPressed: () {
                                Navigator.pop(context); // Close screen
                              },
                            );
                          },
                          child: const Text('Save', style: TextStyle(color: AppColors.primaryAccent)),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () {
                final actionName = isArchived ? 'reactivate' : 'archive';
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surfaceHover,
                    title: Text('${isArchived ? 'Reactivate' : 'Archive'} Account?', style: const TextStyle(color: AppColors.textPrimary)),
                    content: Text('Are you sure you want to $actionName this account?', style: const TextStyle(color: AppColors.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          SuccessAlertDialog.show(
                            context,
                            title: isArchived ? 'Account Reactivated' : 'Account Archived',
                            message: 'The account has been successfully ${isArchived ? 'reactivated' : 'archived'}.',
                            onOkPressed: () {
                              Navigator.pop(context); // Close screen
                            },
                          );
                        },
                        child: Text(
                          isArchived ? 'Reactivate' : 'Archive', 
                          style: TextStyle(color: isArchived ? AppColors.positive : AppColors.negative)
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: isArchived ? AppColors.positive : AppColors.negative,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Text(
                isArchived ? 'Reactivate Account' : 'Archive Account',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
