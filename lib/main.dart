import 'package:flutter/material.dart';

void main() {
  runApp(const ISCSanitationApp());
}

class ISCSanitationApp extends StatelessWidget {
  const ISCSanitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISC Sanitation Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E56)),
        scaffoldBackgroundColor: const Color(0xFFF2F5F2),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const PlatformRoot(),
    );
  }
}

class PlatformRoot extends StatefulWidget {
  const PlatformRoot({super.key});

  @override
  State<PlatformRoot> createState() => _PlatformRootState();
}

class _PlatformRootState extends State<PlatformRoot> {
  final PlatformController _controller = PlatformController.seeded();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        if (_controller.currentUser == null) {
          return LoginScreen(controller: _controller);
        }

        return DashboardScreen(controller: _controller);
      },
    );
  }
}

enum UserRole { iscAdmin, csrPartner, governmentOfficer }

class AppUser {
  const AppUser({
    required this.username,
    required this.password,
    required this.displayName,
    required this.organization,
    required this.role,
  });

  final String username;
  final String password;
  final String displayName;
  final String organization;
  final UserRole role;

  String get roleLabel {
    switch (role) {
      case UserRole.iscAdmin:
        return 'ISC Secretariat';
      case UserRole.csrPartner:
        return 'CSR Funder';
      case UserRole.governmentOfficer:
        return 'Government Officer';
    }
  }
}

enum EntryVertical { infrastructure, behaviourChange, wasteManagement, funding }

enum ContributorType { isc, csr, government }

class SanitationBlock {
  const SanitationBlock({
    required this.id,
    required this.state,
    required this.district,
    required this.block,
    required this.gramPanchayats,
    required this.villagesCovered,
    required this.implementingPartners,
    required this.focusAreas,
    required this.csrBudgetLakhs,
    required this.csrUtilizedLakhs,
    required this.governmentFundingLakhs,
    required this.householdsImpacted,
    required this.toiletsBuilt,
    required this.solidWasteUnits,
    required this.liquidWasteUnits,
    required this.behaviourSessions,
    required this.lastUpdated,
  });

  final String id;
  final String state;
  final String district;
  final String block;
  final int gramPanchayats;
  final int villagesCovered;
  final List<String> implementingPartners;
  final List<String> focusAreas;
  final double csrBudgetLakhs;
  final double csrUtilizedLakhs;
  final double governmentFundingLakhs;
  final int householdsImpacted;
  final int toiletsBuilt;
  final int solidWasteUnits;
  final int liquidWasteUnits;
  final int behaviourSessions;
  final DateTime lastUpdated;

  double get impactScore {
    final weighted =
        (householdsImpacted / 1200) +
        (toiletsBuilt / 180) +
        (solidWasteUnits / 8) +
        (liquidWasteUnits / 8) +
        (behaviourSessions / 24);
    return double.parse((weighted * 20).clamp(0, 100).toStringAsFixed(1));
  }

  SanitationBlock copyWith({
    double? csrBudgetLakhs,
    double? csrUtilizedLakhs,
    double? governmentFundingLakhs,
    int? householdsImpacted,
    int? toiletsBuilt,
    int? solidWasteUnits,
    int? liquidWasteUnits,
    int? behaviourSessions,
    DateTime? lastUpdated,
  }) {
    return SanitationBlock(
      id: id,
      state: state,
      district: district,
      block: block,
      gramPanchayats: gramPanchayats,
      villagesCovered: villagesCovered,
      implementingPartners: implementingPartners,
      focusAreas: focusAreas,
      csrBudgetLakhs: csrBudgetLakhs ?? this.csrBudgetLakhs,
      csrUtilizedLakhs: csrUtilizedLakhs ?? this.csrUtilizedLakhs,
      governmentFundingLakhs:
          governmentFundingLakhs ?? this.governmentFundingLakhs,
      householdsImpacted: householdsImpacted ?? this.householdsImpacted,
      toiletsBuilt: toiletsBuilt ?? this.toiletsBuilt,
      solidWasteUnits: solidWasteUnits ?? this.solidWasteUnits,
      liquidWasteUnits: liquidWasteUnits ?? this.liquidWasteUnits,
      behaviourSessions: behaviourSessions ?? this.behaviourSessions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class ReportingEntry {
  const ReportingEntry({
    required this.blockId,
    required this.blockLabel,
    required this.vertical,
    required this.contributor,
    required this.submittedBy,
    required this.organization,
    required this.allocatedBudgetLakhs,
    required this.utilizedBudgetLakhs,
    required this.householdsImpacted,
    required this.assetsCreated,
    required this.notes,
    required this.createdAt,
  });

  final String blockId;
  final String blockLabel;
  final EntryVertical vertical;
  final ContributorType contributor;
  final String submittedBy;
  final String organization;
  final double allocatedBudgetLakhs;
  final double utilizedBudgetLakhs;
  final int householdsImpacted;
  final int assetsCreated;
  final String notes;
  final DateTime createdAt;

  String get verticalLabel {
    switch (vertical) {
      case EntryVertical.infrastructure:
        return 'Infrastructure';
      case EntryVertical.behaviourChange:
        return 'Behaviour Change';
      case EntryVertical.wasteManagement:
        return 'Waste Management';
      case EntryVertical.funding:
        return 'Funding';
    }
  }

  String get contributorLabel {
    switch (contributor) {
      case ContributorType.isc:
        return 'ISC';
      case ContributorType.csr:
        return 'CSR';
      case ContributorType.government:
        return 'Government';
    }
  }
}

enum ProjectStatus { onTrack, atRisk, delayed, completed }

class ActivityProject {
  const ActivityProject({
    required this.name,
    required this.blockId,
    required this.blockLabel,
    required this.partner,
    required this.vertical,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.budgetLakhs,
  });

  final String name;
  final String blockId;
  final String blockLabel;
  final String partner;
  final EntryVertical vertical;
  final ProjectStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int progress;
  final double budgetLakhs;
}

class PlatformUserProfile {
  const PlatformUserProfile({
    required this.name,
    required this.organization,
    required this.role,
    required this.scope,
    required this.status,
  });

  final String name;
  final String organization;
  final UserRole role;
  final String scope;
  final String status;
}

class FundingGapRecord {
  const FundingGapRecord({
    required this.block,
    required this.requiredLakhs,
    required this.availableLakhs,
  });

  final SanitationBlock block;
  final double requiredLakhs;
  final double availableLakhs;

  double get gapLakhs => requiredLakhs - availableLakhs;
  bool get needsAttention => gapLakhs > 0;
}

class PlatformController extends ChangeNotifier {
  PlatformController.seeded()
    : _users = const <AppUser>[
        AppUser(
          username: 'isc_admin',
          password: 'isc123',
          displayName: 'Naina Mehra',
          organization: 'India Sanitation Coalition',
          role: UserRole.iscAdmin,
        ),
        AppUser(
          username: 'csr_funder',
          password: 'csr123',
          displayName: 'Rahul Kapoor',
          organization: 'CSR Alliance Desk',
          role: UserRole.csrPartner,
        ),
        AppUser(
          username: 'gov_officer',
          password: 'gov123',
          displayName: 'Anita Verma',
          organization: 'State SBM Mission',
          role: UserRole.governmentOfficer,
        ),
      ],
      _blocks = <SanitationBlock>[
        SanitationBlock(
          id: 'blk-01',
          state: 'Maharashtra',
          district: 'Nashik',
          block: 'Sinnar',
          gramPanchayats: 18,
          villagesCovered: 42,
          implementingPartners: const <String>[
            'ISC Field Team',
            'WaterAid India',
          ],
          focusAreas: const <String>[
            'ODF Plus',
            'Behaviour Change',
            'Solid and Liquid Waste Management',
          ],
          csrBudgetLakhs: 145,
          csrUtilizedLakhs: 112,
          governmentFundingLakhs: 88,
          householdsImpacted: 1280,
          toiletsBuilt: 154,
          solidWasteUnits: 8,
          liquidWasteUnits: 5,
          behaviourSessions: 24,
          lastUpdated: DateTime(2026, 3, 28),
        ),
        SanitationBlock(
          id: 'blk-02',
          state: 'Telangana',
          district: 'Sangareddy',
          block: 'Kondapur',
          gramPanchayats: 12,
          villagesCovered: 26,
          implementingPartners: const <String>[
            'District Mission Cell',
            'World Vision',
          ],
          focusAreas: const <String>[
            'Plastic Waste Management',
            'Greywater',
            'School WASH',
          ],
          csrBudgetLakhs: 96,
          csrUtilizedLakhs: 67,
          governmentFundingLakhs: 54,
          householdsImpacted: 840,
          toiletsBuilt: 92,
          solidWasteUnits: 5,
          liquidWasteUnits: 7,
          behaviourSessions: 18,
          lastUpdated: DateTime(2026, 3, 30),
        ),
        SanitationBlock(
          id: 'blk-03',
          state: 'Odisha',
          district: 'Ganjam',
          block: 'Chhatrapur',
          gramPanchayats: 15,
          villagesCovered: 31,
          implementingPartners: const <String>[
            'ISC Lighthouse Team',
            'Local NGO Collective',
          ],
          focusAreas: const <String>[
            'Climate Resilience',
            'Circularity',
            'Women-led SHGs',
          ],
          csrBudgetLakhs: 128,
          csrUtilizedLakhs: 82,
          governmentFundingLakhs: 105,
          householdsImpacted: 1015,
          toiletsBuilt: 118,
          solidWasteUnits: 10,
          liquidWasteUnits: 4,
          behaviourSessions: 20,
          lastUpdated: DateTime(2026, 4, 1),
        ),
      ],
      _entries = <ReportingEntry>[
        ReportingEntry(
          blockId: 'blk-01',
          blockLabel: 'Sinnar, Nashik',
          vertical: EntryVertical.infrastructure,
          contributor: ContributorType.csr,
          submittedBy: 'Rahul Kapoor',
          organization: 'CSR Alliance Desk',
          allocatedBudgetLakhs: 20,
          utilizedBudgetLakhs: 15,
          householdsImpacted: 180,
          assetsCreated: 22,
          notes: 'Household toilet retrofits and soak pit support approved.',
          createdAt: DateTime(2026, 3, 28, 11, 30),
        ),
        ReportingEntry(
          blockId: 'blk-02',
          blockLabel: 'Kondapur, Sangareddy',
          vertical: EntryVertical.wasteManagement,
          contributor: ContributorType.isc,
          submittedBy: 'Naina Mehra',
          organization: 'India Sanitation Coalition',
          allocatedBudgetLakhs: 8,
          utilizedBudgetLakhs: 6,
          householdsImpacted: 120,
          assetsCreated: 3,
          notes:
              'Material recovery shed and door-to-door collection pilot tracked.',
          createdAt: DateTime(2026, 3, 30, 15, 10),
        ),
        ReportingEntry(
          blockId: 'blk-03',
          blockLabel: 'Chhatrapur, Ganjam',
          vertical: EntryVertical.funding,
          contributor: ContributorType.government,
          submittedBy: 'Anita Verma',
          organization: 'State SBM Mission',
          allocatedBudgetLakhs: 26,
          utilizedBudgetLakhs: 12,
          householdsImpacted: 0,
          assetsCreated: 0,
          notes: 'SBM-G and JJM convergence allocation for FY 2026-27 entered.',
          createdAt: DateTime(2026, 4, 1, 10, 0),
        ),
      ],
      _projects = <ActivityProject>[
        ActivityProject(
          name: 'ODF Plus Infrastructure Upgrade',
          blockId: 'blk-01',
          blockLabel: 'Sinnar, Nashik',
          partner: 'WaterAid India',
          vertical: EntryVertical.infrastructure,
          status: ProjectStatus.onTrack,
          startDate: DateTime(2026, 1, 10),
          endDate: DateTime(2026, 8, 30),
          progress: 68,
          budgetLakhs: 42,
        ),
        ActivityProject(
          name: 'Plastic Waste Collection Network',
          blockId: 'blk-02',
          blockLabel: 'Kondapur, Sangareddy',
          partner: 'World Vision',
          vertical: EntryVertical.wasteManagement,
          status: ProjectStatus.atRisk,
          startDate: DateTime(2026, 2, 5),
          endDate: DateTime(2026, 9, 15),
          progress: 46,
          budgetLakhs: 28,
        ),
        ActivityProject(
          name: 'Climate Resilient Village Sanitation',
          blockId: 'blk-03',
          blockLabel: 'Chhatrapur, Ganjam',
          partner: 'ISC Lighthouse Team',
          vertical: EntryVertical.behaviourChange,
          status: ProjectStatus.delayed,
          startDate: DateTime(2026, 1, 20),
          endDate: DateTime(2026, 10, 30),
          progress: 39,
          budgetLakhs: 35,
        ),
      ],
      _platformUsers = const <PlatformUserProfile>[
        PlatformUserProfile(
          name: 'Naina Mehra',
          organization: 'India Sanitation Coalition',
          role: UserRole.iscAdmin,
          scope: 'National platform administration',
          status: 'Active',
        ),
        PlatformUserProfile(
          name: 'Rahul Kapoor',
          organization: 'CSR Alliance Desk',
          role: UserRole.csrPartner,
          scope: 'CSR budget submission and partner mapping',
          status: 'Active',
        ),
        PlatformUserProfile(
          name: 'Anita Verma',
          organization: 'State SBM Mission',
          role: UserRole.governmentOfficer,
          scope: 'Government funding convergence and block oversight',
          status: 'Active',
        ),
      ];

  final List<AppUser> _users;
  final List<SanitationBlock> _blocks;
  final List<ReportingEntry> _entries;
  final List<ActivityProject> _projects;
  final List<PlatformUserProfile> _platformUsers;

  AppUser? currentUser;
  int pendingChanges = 0;
  DateTime? lastSyncAt;
  bool isSyncing = false;

  List<SanitationBlock> get blocks =>
      List<SanitationBlock>.unmodifiable(_blocks);
  List<ReportingEntry> get entries =>
      List<ReportingEntry>.unmodifiable(_entries.reversed);
  List<ActivityProject> get projects =>
      List<ActivityProject>.unmodifiable(_projects);
  List<PlatformUserProfile> get platformUsers =>
      List<PlatformUserProfile>.unmodifiable(_platformUsers);
  List<ImplementationPartnerSummary> get partnerSummaries {
    final Map<String, List<SanitationBlock>> partnerBlocks =
        <String, List<SanitationBlock>>{};

    for (final SanitationBlock block in _blocks) {
      for (final String partner in block.implementingPartners) {
        partnerBlocks
            .putIfAbsent(partner, () => <SanitationBlock>[])
            .add(block);
      }
    }

    final List<ImplementationPartnerSummary> summaries =
        partnerBlocks.entries
            .map(
              (MapEntry<String, List<SanitationBlock>> entry) =>
                  ImplementationPartnerSummary(
                    name: entry.key,
                    blocks: entry.value,
                  ),
            )
            .toList()
          ..sort(
            (ImplementationPartnerSummary a, ImplementationPartnerSummary b) =>
                a.name.compareTo(b.name),
          );

    return summaries;
  }

  List<FundingGapRecord> get fundingGapRecords {
    return _blocks
        .map(
          (SanitationBlock block) => FundingGapRecord(
            block: block,
            requiredLakhs: block.csrBudgetLakhs + 30,
            availableLakhs: block.csrBudgetLakhs + block.governmentFundingLakhs,
          ),
        )
        .toList()
      ..sort(
        (FundingGapRecord a, FundingGapRecord b) =>
            b.gapLakhs.compareTo(a.gapLakhs),
      );
  }

  int get atRiskProjectCount => _projects
      .where(
        (ActivityProject project) =>
            project.status == ProjectStatus.atRisk ||
            project.status == ProjectStatus.delayed,
      )
      .length;

  int get totalVillagesCovered => _blocks.fold<int>(
    0,
    (int total, SanitationBlock block) => total + block.villagesCovered,
  );

  int get totalHouseholdsImpacted => _blocks.fold<int>(
    0,
    (int total, SanitationBlock block) => total + block.householdsImpacted,
  );

  double get totalCsrBudgetLakhs => _blocks.fold<double>(
    0,
    (double total, SanitationBlock block) => total + block.csrBudgetLakhs,
  );

  double get totalGovernmentFundingLakhs => _blocks.fold<double>(
    0,
    (double total, SanitationBlock block) =>
        total + block.governmentFundingLakhs,
  );

  bool login(String username, String password) {
    try {
      currentUser = _users.firstWhere(
        (AppUser user) =>
            user.username == username.trim().toLowerCase() &&
            user.password == password,
      );
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  Future<void> addEntry({
    required String blockId,
    required EntryVertical vertical,
    required double allocatedBudgetLakhs,
    required double utilizedBudgetLakhs,
    required int householdsImpacted,
    required int assetsCreated,
    required String notes,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final blockIndex = _blocks.indexWhere(
      (SanitationBlock block) => block.id == blockId,
    );
    if (blockIndex == -1) {
      return;
    }

    final block = _blocks[blockIndex];
    final entry = ReportingEntry(
      blockId: block.id,
      blockLabel: '${block.block}, ${block.district}',
      vertical: vertical,
      contributor: _contributorFor(user.role),
      submittedBy: user.displayName,
      organization: user.organization,
      allocatedBudgetLakhs: allocatedBudgetLakhs,
      utilizedBudgetLakhs: utilizedBudgetLakhs,
      householdsImpacted: householdsImpacted,
      assetsCreated: assetsCreated,
      notes: notes,
      createdAt: DateTime.now(),
    );

    _entries.add(entry);
    _blocks[blockIndex] = block.copyWith(
      csrBudgetLakhs: user.role == UserRole.csrPartner
          ? block.csrBudgetLakhs + allocatedBudgetLakhs
          : block.csrBudgetLakhs,
      csrUtilizedLakhs: user.role == UserRole.csrPartner
          ? block.csrUtilizedLakhs + utilizedBudgetLakhs
          : block.csrUtilizedLakhs,
      governmentFundingLakhs: user.role == UserRole.governmentOfficer
          ? block.governmentFundingLakhs + allocatedBudgetLakhs
          : block.governmentFundingLakhs,
      householdsImpacted: block.householdsImpacted + householdsImpacted,
      toiletsBuilt: vertical == EntryVertical.infrastructure
          ? block.toiletsBuilt + assetsCreated
          : block.toiletsBuilt,
      solidWasteUnits: vertical == EntryVertical.wasteManagement
          ? block.solidWasteUnits + assetsCreated
          : block.solidWasteUnits,
      liquidWasteUnits: vertical == EntryVertical.wasteManagement
          ? block.liquidWasteUnits + (assetsCreated ~/ 2)
          : block.liquidWasteUnits,
      behaviourSessions: vertical == EntryVertical.behaviourChange
          ? block.behaviourSessions + assetsCreated
          : block.behaviourSessions,
      lastUpdated: DateTime.now(),
    );

    pendingChanges += 1;
    notifyListeners();
  }

  Future<void> sync() async {
    if (isSyncing) {
      return;
    }

    isSyncing = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 900));

    isSyncing = false;
    pendingChanges = 0;
    lastSyncAt = DateTime.now();
    notifyListeners();
  }

  ContributorType _contributorFor(UserRole role) {
    switch (role) {
      case UserRole.iscAdmin:
        return ContributorType.isc;
      case UserRole.csrPartner:
        return ContributorType.csr;
      case UserRole.governmentOfficer:
        return ContributorType.government;
    }
  }
}

class ImplementationPartnerSummary {
  const ImplementationPartnerSummary({
    required this.name,
    required this.blocks,
  });

  final String name;
  final List<SanitationBlock> blocks;

  int get totalVillagesCovered => blocks.fold<int>(
    0,
    (int total, SanitationBlock block) => total + block.villagesCovered,
  );

  int get totalHouseholdsImpacted => blocks.fold<int>(
    0,
    (int total, SanitationBlock block) => total + block.householdsImpacted,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.controller, super.key});

  final PlatformController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showHint = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final success = widget.controller.login(
      _userController.text,
      _passwordController.text,
    );

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials.')));
      setState(() => _showHint = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF123B38),
              Color(0xFF2C756B),
              Color(0xFFF2F5F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final isCompact = constraints.maxWidth < 760;
                          if (isCompact) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const LoginIntroPanel(),
                                _LoginFormPanel(
                                  userController: _userController,
                                  passwordController: _passwordController,
                                  showHint: _showHint,
                                  onLogin: _login,
                                ),
                              ],
                            );
                          }

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Expanded(child: LoginIntroPanel()),
                                Expanded(
                                  child: _LoginFormPanel(
                                    userController: _userController,
                                    passwordController: _passwordController,
                                    showHint: _showHint,
                                    onLogin: _login,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginIntroPanel extends StatelessWidget {
  const LoginIntroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF123B38),
      padding: const EdgeInsets.all(28),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ISC Unified Sanitation Monitoring Platform',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'A one-view zone for block-level implementation progress, funding clarity, partner mapping, and impact reporting.',
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 24),
          LoginFeature(
            title: 'Shared visibility',
            subtitle:
                'ISC, corporates, and government work from the same dashboard.',
          ),
          SizedBox(height: 14),
          LoginFeature(
            title: 'Block-level reporting',
            subtitle:
                'Capture clarity on budgets, partners, outputs, and impact by block.',
          ),
          SizedBox(height: 14),
          LoginFeature(
            title: 'Multi-vertical entry',
            subtitle:
                'Submit updates for infrastructure, behaviour change, waste management, and funding.',
          ),
        ],
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({
    required this.userController,
    required this.passwordController,
    required this.showHint,
    required this.onLogin,
  });

  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool showHint;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Platform Sign In',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Access a shared sanitation monitoring workspace for ISC, CSR funders, and government agencies.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: userController,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'isc_admin',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'isc123',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onLogin, child: const Text('Enter Platform')),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Demo users:\n'
              'isc_admin / isc123\n'
              'csr_funder / csr123\n'
              'gov_officer / gov123',
            ),
          ),
          if (showHint) ...[
            const SizedBox(height: 12),
            const Text(
              'Use one of the demo role accounts above to explore the app.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}

class LoginFeature extends StatelessWidget {
  const LoginFeature({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF7DD2BA),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardDestination {
  const _DashboardDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.description,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String description;
  final Widget Function(PlatformController controller) builder;
}

class _ResponsivePage extends StatelessWidget {
  const _ResponsivePage({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final compact = _isCompactWidth(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 16,
        compact ? 12 : 16,
        compact ? 12 : 16,
        compact ? 20 : 28,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _withVerticalSpacing(children, 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveHeaderWithChip extends StatelessWidget {
  const _AdaptiveHeaderWithChip({required this.title, required this.chip});

  final Widget title;
  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 8), chip],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            const SizedBox(width: 12),
            chip,
          ],
        );
      },
    );
  }
}

class _AdaptiveFieldPair extends StatelessWidget {
  const _AdaptiveFieldPair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 720) {
          return Column(children: [first, const SizedBox(height: 12), second]);
        }

        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.user,
    required this.destination,
    required this.controller,
    required this.onSync,
    required this.onLogout,
    required this.compact,
  });

  final AppUser user;
  final _DashboardDestination destination;
  final PlatformController controller;
  final Future<void> Function() onSync;
  final VoidCallback onLogout;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        compact ? 16 : 20,
        compact ? 12 : 16,
        compact ? 16 : 20,
        0,
      ),
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 18,
        compact ? 16 : 16,
        compact ? 16 : 18,
        compact ? 16 : 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF123B38), Color(0xFF2C756B)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24123B38),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            destination.label,
                            style: titleTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _CompactHeroAction(
                          icon: controller.isSyncing
                              ? Icons.hourglass_top
                              : Icons.sync,
                          tooltip: controller.isSyncing ? 'Syncing' : 'Sync',
                          onTap: controller.isSyncing ? null : () => onSync(),
                        ),
                        const SizedBox(width: 8),
                        _CompactHeroAction(
                          icon: Icons.logout,
                          tooltip: 'Logout',
                          onTap: onLogout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${user.displayName} • ${user.roleLabel}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      destination.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        HeaderChip(
                          label: 'Blocks',
                          value: controller.blocks.length.toString(),
                          compact: true,
                        ),
                        HeaderChip(
                          label: 'Pending',
                          value: controller.pendingChanges.toString(),
                          compact: true,
                        ),
                        HeaderChip(
                          label: 'Status',
                          value: controller.isSyncing ? 'Syncing' : 'Ready',
                          compact: true,
                        ),
                        HeaderChip(
                          label: 'Last sync',
                          value: formatDateTime(controller.lastSyncAt),
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ISC Unified Sanitation Platform',
                                  style: titleTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 27,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${user.displayName} • ${user.roleLabel} • ${user.organization}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  destination.label,
                                  style: titleTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  destination.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedButton.icon(
                              onPressed: controller.isSyncing ? null : onSync,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                              ),
                              icon: const Icon(Icons.sync),
                              label: Text(
                                controller.isSyncing
                                    ? 'Syncing...'
                                    : 'Sync Now',
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: onLogout,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                              ),
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        HeaderChip(
                          label: 'Blocks tracked',
                          value: controller.blocks.length.toString(),
                        ),
                        HeaderChip(
                          label: 'Pending sync',
                          value: controller.pendingChanges.toString(),
                        ),
                        HeaderChip(
                          label: 'Status',
                          value: controller.isSyncing ? 'Syncing...' : 'Ready',
                        ),
                        HeaderChip(
                          label: 'Last sync',
                          value: formatDateTime(controller.lastSyncAt),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CompactHeroAction extends StatelessWidget {
  const _CompactHeroAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

List<Widget> _withVerticalSpacing(List<Widget> children, double spacing) {
  final List<Widget> result = <Widget>[];
  for (var index = 0; index < children.length; index++) {
    if (index > 0) {
      result.add(SizedBox(height: spacing));
    }
    result.add(children[index]);
  }
  return result;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.controller, super.key});

  final PlatformController controller;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<_DashboardDestination> get _destinations => <_DashboardDestination>[
    _DashboardDestination(
      label: 'Overview',
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      description:
          'Monitor headline sanitation metrics, funding snapshots, and impact coverage in one place.',
      builder: (PlatformController controller) =>
          OverviewPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Block View',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map,
      description:
          'Review every tracked block, including funding, focus areas, and implementation partners working there.',
      builder: (PlatformController controller) =>
          BlocksPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Funding',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      description:
          'Compare modeled funding requirements against available CSR and government support.',
      builder: (PlatformController controller) =>
          FundingGapPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Projects',
      icon: Icons.task_alt_outlined,
      selectedIcon: Icons.task_alt,
      description:
          'Track implementation projects, delivery status, budgets, and activity progress.',
      builder: (PlatformController controller) =>
          ProjectTrackerPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Partners',
      icon: Icons.handshake_outlined,
      selectedIcon: Icons.handshake,
      description:
          'See implementation partner coverage and which blocks each partner is currently working in.',
      builder: (PlatformController controller) =>
          ImplementationPartnersPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Reports',
      icon: Icons.file_download_outlined,
      selectedIcon: Icons.file_download,
      description:
          'Access report-ready summaries for ISC, CSR, government, and partner reviews.',
      builder: (PlatformController controller) =>
          ReportsExportPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Users',
      icon: Icons.manage_accounts_outlined,
      selectedIcon: Icons.manage_accounts,
      description:
          'Manage role-based access for ISC teams, CSR funders, and government officers.',
      builder: (PlatformController controller) =>
          UserManagementPage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Performance',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
      description:
          'Compare partner performance by block spread, villages covered, and households linked.',
      builder: (PlatformController controller) =>
          PartnerPerformancePage(controller: controller),
    ),
    _DashboardDestination(
      label: 'Data Entry',
      icon: Icons.edit_note_outlined,
      selectedIcon: Icons.edit_note,
      description:
          'Capture field updates, budget allocations, and implementation notes from a mobile-friendly form.',
      builder: (PlatformController controller) =>
          DataEntryPage(controller: controller),
    ),
  ];

  Future<void> _sync() async {
    await widget.controller.sync();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Platform data synced.')));
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.controller.currentUser!;
    final destination = _destinations[_selectedIndex];
    final selectedPage = destination.builder(widget.controller);
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 1040;
    final extendRail = width >= 1360;

    return Scaffold(
      appBar: useRail
          ? null
          : AppBar(
              title: const Text('ISC Platform'),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF123B38),
              elevation: 0,
              toolbarHeight: 60,
            ),
      drawer: useRail
          ? null
          : NavigationDrawer(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int value) {
                setState(() => _selectedIndex = value);
                Navigator.of(context).pop();
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ISC Platform',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.roleLabel,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                ...List<Widget>.generate(_destinations.length, (int index) {
                  final item = _destinations[index];
                  return NavigationDrawerDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(item.label),
                  );
                }),
              ],
            ),
      body: SafeArea(
        top: useRail,
        child: Row(
          children: [
            if (useRail)
              Container(
                width: extendRail ? 300 : 104,
                margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFDDE6E2)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        extendRail ? 24 : 12,
                        20,
                        extendRail ? 24 : 12,
                        12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF123B38),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.water_drop_outlined,
                              color: Colors.white,
                            ),
                          ),
                          if (extendRail) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ISC Platform',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: NavigationRail(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (int value) {
                          setState(() => _selectedIndex = value);
                        },
                        extended: extendRail,
                        minWidth: 88,
                        minExtendedWidth: 280,
                        labelType: extendRail
                            ? NavigationRailLabelType.none
                            : NavigationRailLabelType.all,
                        backgroundColor: Colors.transparent,
                        destinations: _destinations
                            .map(
                              (_DashboardDestination item) =>
                                  NavigationRailDestination(
                                    icon: Icon(item.icon),
                                    selectedIcon: Icon(item.selectedIcon),
                                    label: Text(item.label),
                                  ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  _DashboardHero(
                    user: user,
                    destination: destination,
                    controller: widget.controller,
                    onSync: _sync,
                    onLogout: widget.controller.logout,
                    compact: !useRail,
                  ),
                  Expanded(child: selectedPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    final topBlock = controller.blocks.reduce(
      (SanitationBlock a, SanitationBlock b) =>
          a.impactScore >= b.impactScore ? a : b,
    );

    return _ResponsivePage(
      children: [
        Container(
          padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF123B38), Color(0xFF2C756B)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'One-view decision dashboard',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Designed for ISC, CSR organizations, and government agencies to review funding, implementation coverage, and impact from a shared dashboard.',
                style: TextStyle(color: Colors.white70, height: 1.45),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _ThemeBadge(label: 'Funding clarity'),
                  _ThemeBadge(label: 'Block intelligence'),
                  _ThemeBadge(label: 'Partner coverage'),
                ],
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final wide = constraints.maxWidth > 900;
            final cardWidth = wide
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    title: 'CSR Budget Allocated',
                    value:
                        'INR ${formatLakhs(controller.totalCsrBudgetLakhs)} L',
                    icon: Icons.account_balance_wallet,
                    color: const Color(0xFF21584F),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    title: 'Government Funding',
                    value:
                        'INR ${formatLakhs(controller.totalGovernmentFundingLakhs)} L',
                    icon: Icons.gavel,
                    color: const Color(0xFF3C7A56),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    title: 'Villages Covered',
                    value: controller.totalVillagesCovered.toString(),
                    icon: Icons.location_city,
                    color: const Color(0xFF809A45),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    title: 'Households Impacted',
                    value: controller.totalHouseholdsImpacted.toString(),
                    icon: Icons.people_alt,
                    color: const Color(0xFFB8820E),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority block snapshot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${topBlock.block}, ${topBlock.district}, ${topBlock.state}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Impact score ${topBlock.impactScore}, ${topBlock.gramPanchayats} GPs, ${topBlock.villagesCovered} villages, and ${topBlock.implementingPartners.join(', ')} driving implementation.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topBlock.focusAreas
                      .map(
                        (String item) => Chip(
                          backgroundColor: const Color(0xFFE4F2EE),
                          label: Text(item),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4F0),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD7E9E3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform coverage',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF123B38),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ISC updates block-level implementation data. CSR organizations enter area-wise budgets and implementation partners. Government users add scheme-linked allocations to create a unified clarity layer for decision-making.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlocksPage extends StatelessWidget {
  const BlocksPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsivePage(
      children: controller.blocks.map((SanitationBlock block) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Block-level view',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF21584F),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                _AdaptiveHeaderWithChip(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${block.block}, ${block.district}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${block.state} • ${block.gramPanchayats} GPs • ${block.villagesCovered} villages',
                      ),
                    ],
                  ),
                  chip: Chip(label: Text('Impact ${block.impactScore}')),
                ),
                const SizedBox(height: 14),
                Text(
                  'Implementation partners working in this block',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: block.implementingPartners
                      .map(
                        (String partner) => Chip(
                          avatar: const Icon(Icons.business, size: 18),
                          label: Text(partner),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MetricPill(
                      label: 'CSR allocated',
                      value: 'INR ${formatLakhs(block.csrBudgetLakhs)} L',
                    ),
                    MetricPill(
                      label: 'CSR utilized',
                      value: 'INR ${formatLakhs(block.csrUtilizedLakhs)} L',
                    ),
                    MetricPill(
                      label: 'Govt funding',
                      value:
                          'INR ${formatLakhs(block.governmentFundingLakhs)} L',
                    ),
                    MetricPill(
                      label: 'Households',
                      value: block.householdsImpacted.toString(),
                    ),
                    MetricPill(
                      label: 'Toilets',
                      value: block.toiletsBuilt.toString(),
                    ),
                    MetricPill(
                      label: 'SWM units',
                      value: block.solidWasteUnits.toString(),
                    ),
                    MetricPill(
                      label: 'LWM units',
                      value: block.liquidWasteUnits.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Focus areas: ${block.focusAreas.join(' • ')}'),
                const SizedBox(height: 8),
                Text('Last updated: ${formatDateTime(block.lastUpdated)}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ImplementationPartnersPage extends StatelessWidget {
  const ImplementationPartnersPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    final List<ImplementationPartnerSummary> partners =
        controller.partnerSummaries;

    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Implementation partner level view',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'See every implementation partner, the blocks they are active in, and the combined reach linked to those blocks.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...partners.map(
          (ImplementationPartnerSummary partner) => Card(
            child: Padding(
              padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdaptiveHeaderWithChip(
                    title: Text(
                      partner.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    chip: Chip(
                      label: Text('${partner.blocks.length} block(s)'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MetricPill(
                        label: 'Villages covered',
                        value: partner.totalVillagesCovered.toString(),
                      ),
                      MetricPill(
                        label: 'Households linked',
                        value: partner.totalHouseholdsImpacted.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Blocks where this partner is working',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...partner.blocks.map(
                    (SanitationBlock block) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${block.block}, ${block.district}, ${block.state}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${block.gramPanchayats} GPs • ${block.villagesCovered} villages • Impact ${block.impactScore}',
                                ),
                                const SizedBox(height: 4),
                                Text('Focus: ${block.focusAreas.join(' • ')}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FundingGapPage extends StatelessWidget {
  const FundingGapPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    final records = controller.fundingGapRecords;
    final totalGap = records.fold<double>(
      0,
      (double sum, FundingGapRecord record) => sum + record.gapLakhs,
    );

    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Funding gap analysis',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total modeled gap across tracked blocks: INR ${formatLakhs(totalGap)} L',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...records.map(
          (FundingGapRecord record) => Card(
            child: Padding(
              padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdaptiveHeaderWithChip(
                    title: Text(
                      '${record.block.block}, ${record.block.district}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    chip: Chip(
                      label: Text(
                        record.needsAttention
                            ? 'Gap ${formatLakhs(record.gapLakhs)} L'
                            : 'Covered',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MetricPill(
                        label: 'Required',
                        value: 'INR ${formatLakhs(record.requiredLakhs)} L',
                      ),
                      MetricPill(
                        label: 'Available',
                        value: 'INR ${formatLakhs(record.availableLakhs)} L',
                      ),
                      MetricPill(
                        label: 'CSR utilized',
                        value:
                            'INR ${formatLakhs(record.block.csrUtilizedLakhs)} L',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProjectTrackerPage extends StatelessWidget {
  const ProjectTrackerPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project and activity tracker',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.projects.length} active projects, ${controller.atRiskProjectCount} needing close attention.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...controller.projects.map(
          (ActivityProject project) => Card(
            child: Padding(
              padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdaptiveHeaderWithChip(
                    title: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    chip: Chip(label: Text(projectStatusLabel(project.status))),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${project.blockLabel} • ${project.partner} • ${verticalLabel(project.vertical)}',
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: project.progress / 100,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Progress ${project.progress}% • Budget INR ${formatLakhs(project.budgetLakhs)} L • ${formatDateTime(project.startDate)} to ${formatDateTime(project.endDate)}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportsExportPage extends StatelessWidget {
  const ReportsExportPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports and export',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Prepared report packs for ISC review, CSR funding updates, government convergence review, and partner performance reporting.',
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    MetricPill(label: 'ISC summary', value: 'Ready'),
                    MetricPill(label: 'CSR report', value: 'Ready'),
                    MetricPill(label: 'Government brief', value: 'Ready'),
                    MetricPill(label: 'Partner scorecard', value: 'Ready'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User and role management',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage platform access for ISC admins, CSR funders, and government officers.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...controller.platformUsers.map(
          (PlatformUserProfile user) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(user.name.substring(0, 1))),
              title: Text(user.name),
              subtitle: Text(
                '${user.organization}\n${user.scope}\n${roleLabel(user.role)} • ${user.status}',
              ),
              isThreeLine: true,
            ),
          ),
        ),
      ],
    );
  }
}

class PartnerPerformancePage extends StatelessWidget {
  const PartnerPerformancePage({required this.controller, super.key});

  final PlatformController controller;

  @override
  Widget build(BuildContext context) {
    final partners = controller.partnerSummaries;
    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partner performance dashboard',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Compare implementation partners by spread across blocks, villages covered, and households linked.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...partners.map(
          (ImplementationPartnerSummary partner) => Card(
            child: Padding(
              padding: EdgeInsets.all(_isCompactWidth(context) ? 16 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MetricPill(
                        label: 'Blocks active',
                        value: partner.blocks.length.toString(),
                      ),
                      MetricPill(
                        label: 'Villages covered',
                        value: partner.totalVillagesCovered.toString(),
                      ),
                      MetricPill(
                        label: 'Households linked',
                        value: partner.totalHouseholdsImpacted.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({required this.controller, super.key});

  final PlatformController controller;

  @override
  State<DataEntryPage> createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController _allocatedController = TextEditingController(
    text: '5',
  );
  final TextEditingController _utilizedController = TextEditingController(
    text: '3',
  );
  final TextEditingController _householdsController = TextEditingController(
    text: '50',
  );
  final TextEditingController _assetsController = TextEditingController(
    text: '2',
  );
  final TextEditingController _notesController = TextEditingController();

  String? _selectedBlockId;
  EntryVertical _selectedVertical = EntryVertical.infrastructure;

  @override
  void initState() {
    super.initState();
    if (widget.controller.blocks.isNotEmpty) {
      _selectedBlockId = widget.controller.blocks.first.id;
    }
  }

  @override
  void dispose() {
    _allocatedController.dispose();
    _utilizedController.dispose();
    _householdsController.dispose();
    _assetsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final blockId = _selectedBlockId;
    if (blockId == null) {
      return;
    }

    await widget.controller.addEntry(
      blockId: blockId,
      vertical: _selectedVertical,
      allocatedBudgetLakhs: double.tryParse(_allocatedController.text) ?? 0,
      utilizedBudgetLakhs: double.tryParse(_utilizedController.text) ?? 0,
      householdsImpacted: int.tryParse(_householdsController.text) ?? 0,
      assetsCreated: int.tryParse(_assetsController.text) ?? 0,
      notes: _notesController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Block update saved locally and queued for sync.'),
      ),
    );
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _ResponsivePage(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submit a block-level update',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Capture new implementation activity, budget allocation, or government funding across the sanitation verticals.',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBlockId,
                  decoration: const InputDecoration(labelText: 'Block'),
                  items: widget.controller.blocks
                      .map(
                        (SanitationBlock block) => DropdownMenuItem<String>(
                          value: block.id,
                          child: Text('${block.block}, ${block.district}'),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() => _selectedBlockId = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<EntryVertical>(
                  value: _selectedVertical,
                  decoration: const InputDecoration(labelText: 'Vertical'),
                  items: EntryVertical.values
                      .map(
                        (EntryVertical vertical) =>
                            DropdownMenuItem<EntryVertical>(
                              value: vertical,
                              child: Text(verticalLabel(vertical)),
                            ),
                      )
                      .toList(),
                  onChanged: (EntryVertical? value) {
                    if (value != null) {
                      setState(() => _selectedVertical = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _AdaptiveFieldPair(
                  first: TextField(
                    controller: _allocatedController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Budget allocated (lakhs)',
                    ),
                  ),
                  second: TextField(
                    controller: _utilizedController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Budget utilized (lakhs)',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _AdaptiveFieldPair(
                  first: TextField(
                    controller: _householdsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Households impacted',
                    ),
                  ),
                  second: TextField(
                    controller: _assetsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Assets or sessions created',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Implementation notes',
                    hintText:
                        'Describe the activity, implementation partner, or funding decision.',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _saveEntry,
                  icon: const Icon(Icons.save),
                  label: const Text('Save update'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Recent submissions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        ...widget.controller.entries
            .take(6)
            .map(
              (ReportingEntry entry) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE3F2EE),
                    child: Text(entry.contributorLabel.substring(0, 1)),
                  ),
                  title: Text('${entry.verticalLabel} • ${entry.blockLabel}'),
                  subtitle: Text(
                    '${entry.organization}\n'
                    '${entry.notes.isEmpty ? 'No notes added.' : entry.notes}',
                  ),
                  trailing: Text(
                    '${formatLakhs(entry.allocatedBudgetLakhs)} L',
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
      ],
    );
  }
}

class HeaderChip extends StatelessWidget {
  const HeaderChip({
    required this.label,
    required this.value,
    this.compact = false,
    super.key,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.white, fontSize: compact ? 12 : 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white70,
                fontSize: compact ? 12 : 14,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _ThemeBadge extends StatelessWidget {
  const _ThemeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final compact = _isCompactWidth(context);
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(compact ? 18 : 20),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final compact = _isCompactWidth(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F3),
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: compact ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

bool _isCompactWidth(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

String verticalLabel(EntryVertical vertical) {
  switch (vertical) {
    case EntryVertical.infrastructure:
      return 'Infrastructure';
    case EntryVertical.behaviourChange:
      return 'Behaviour Change';
    case EntryVertical.wasteManagement:
      return 'Waste Management';
    case EntryVertical.funding:
      return 'Funding';
  }
}

String projectStatusLabel(ProjectStatus status) {
  switch (status) {
    case ProjectStatus.onTrack:
      return 'On Track';
    case ProjectStatus.atRisk:
      return 'At Risk';
    case ProjectStatus.delayed:
      return 'Delayed';
    case ProjectStatus.completed:
      return 'Completed';
  }
}

String roleLabel(UserRole role) {
  switch (role) {
    case UserRole.iscAdmin:
      return 'ISC Secretariat';
    case UserRole.csrPartner:
      return 'CSR Funder';
    case UserRole.governmentOfficer:
      return 'Government Officer';
  }
}

String formatLakhs(double value) {
  return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
}

String formatDateTime(DateTime? value) {
  if (value == null) {
    return 'Never';
  }

  final String day = value.day.toString().padLeft(2, '0');
  final String month = value.month.toString().padLeft(2, '0');
  final String year = value.year.toString();
  final String hour = value.hour.toString().padLeft(2, '0');
  final String minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}
