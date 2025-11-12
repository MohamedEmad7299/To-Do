import 'dart:io';

class AssetInfo {
  final String path;
  final bool isGenerated;
  final String sourceFile;
  final String? constantName;
  final String? getterChain;
  final String? category; // e.g., 'icons', 'images', 'jsons'
  final String? fullAccessorPath; // e.g., 'Assets.icons.alarm'

  AssetInfo({
    required this.path,
    required this.isGenerated,
    required this.sourceFile,
    this.constantName,
    this.getterChain,
    this.category,
    this.fullAccessorPath,
  });
}

class FlutterCleanup {
  static const String GREEN = '\x1B[32m';
  static const String YELLOW = '\x1B[33m';
  static const String RED = '\x1B[31m';
  static const String BLUE = '\x1B[34m';
  static const String CYAN = '\x1B[36m';
  static const String BOLD = '\x1B[1m';
  static const String RESET = '\x1B[0m';

  Set<String> unusedPackages = {};
  Set<String> unusedAssets = {};
  Map<String, List<String>> packageUsage = {};
  Map<String, String> pubspecPackages = {};
  String projectName = '';

  Future<void> run() async {
    await showMainMenu();
  }

  Future<void> showMainMenu() async {
    // Ensure stdin is properly configured
    if (stdin.hasTerminal) {
      stdin.echoMode = true;
      stdin.lineMode = true;
    }

    while (true) {
      printHeader();

      print('${BOLD}Select an option:${RESET}\n');
      print('  ${CYAN}1.${RESET} Check unused packages');
      print('  ${CYAN}2.${RESET} Check unused assets');
      print('  ${CYAN}3.${RESET} Check all (packages + assets)');
      print('  ${CYAN}4.${RESET} Remove unused packages');
      print('  ${CYAN}5.${RESET} Remove unused assets');
      print('  ${CYAN}6.${RESET} Quick cleanup (remove all)');
      print('  ${RED}0.${RESET} Exit\n');

      stdout.write('${BOLD}Enter your choice: ${RESET}');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await checkPackages();
          break;
        case '2':
          await checkAssets();
          break;
        case '3':
          await checkAll();
          break;
        case '4':
          await removePackages();
          break;
        case '5':
          await removeAssets();
          break;
        case '6':
          await quickCleanup();
          break;
        case '0':
          print('\n${GREEN}Goodbye! 👋${RESET}');
          exit(0);
        default:
          print('${RED}Invalid option. Please try again.${RESET}');
      }

      if (choice != '0') {
        await waitForUser();
      }
    }
  }

  void printHeader() {
    print('\n${BLUE}╔════════════════════════════════════════╗${RESET}');
    print(
      '${BLUE}║    ${BOLD}Flutter Cleanup Tool v2.0${RESET}${BLUE}          ║${RESET}',
    );
    print(
      '${BLUE}║        ${CYAN}(Standalone Version)${RESET}${BLUE}           ║${RESET}',
    );
    print('${BLUE}╚════════════════════════════════════════╝${RESET}\n');
  }

  bool _isEssentialPackage(String package) {
    // Essential Flutter and Dart packages
    const essentialPackages = [
      'flutter',
      'flutter_test',
      'flutter_localizations',
      'cupertino_icons',
      'flutter_lints',
      'flutter_driver',
      'integration_test',
    ];
    return essentialPackages.contains(package);
  }

  bool _isBuildTool(String package) {
    // Build tools and code generators (don't need direct imports)
    const buildTools = [
      'build_runner',
      'build',
      'build_config',
      'build_daemon',
      'build_resolvers',
      'build_test',
      'json_serializable',
      'json_annotation',
      'freezed',
      'freezed_annotation',
      'retrofit_generator',
      'injectable_generator',
      'auto_route_generator',
      'flutter_gen',
      'flutter_gen_runner',
      'flutter_launcher_icons',
      'flutter_native_splash',
      'flutter_flavorizr',
      'icons_launcher',
      'change_app_package_name',
      'dart_style',
      'analyzer',
      'source_gen',
      'code_builder',
    ];
    return buildTools.contains(package);
  }

  Future<Set<String>> findPackagesUsedInConfig() async {
    final configUsedPackages = <String>{};
    final pubspecFile = File('pubspec.yaml');

    if (!pubspecFile.existsSync()) {
      return configUsedPackages;
    }

    final content = await pubspecFile.readAsString();

    // Check for flutter_launcher_icons configuration
    if (content.contains('flutter_icons:') ||
        content.contains('flutter_launcher_icons:')) {
      configUsedPackages.add('flutter_launcher_icons');
    }

    // Check for flutter_native_splash configuration
    if (content.contains('flutter_native_splash:')) {
      configUsedPackages.add('flutter_native_splash');
    }

    // Check for flutter_flavorizr configuration
    if (content.contains('flavorizr:')) {
      configUsedPackages.add('flutter_flavorizr');
    }

    // Check for flutter_gen configuration
    if (content.contains('flutter_gen:')) {
      configUsedPackages.add('flutter_gen');
      configUsedPackages.add('flutter_gen_runner');
    }

    // Database packages are often used through abstractions
    // Check for common database-related files
    final libDir = Directory('lib');
    if (libDir.existsSync()) {
      await for (final file in libDir.list(recursive: true)) {
        if (file is File && file.path.endsWith('.dart')) {
          final fileName = file.path.toLowerCase();
          final fileContent = await file.readAsString();

          // Check for database-related patterns
          if (fileName.contains('database') ||
              fileName.contains('db_') ||
              fileName.contains('_db.') ||
              fileContent.contains('Database') ||
              fileContent.contains('openDatabase') ||
              fileContent.contains('databaseFactory')) {
            configUsedPackages.add('sqflite');
            configUsedPackages.add('sqflite_common');
            configUsedPackages.add('sqflite_common_ffi');
          }

          // Check for ObjectBox usage
          if (fileName.contains('objectbox') ||
              fileContent.contains('Store(')) {
            configUsedPackages.add('objectbox');
            configUsedPackages.add('objectbox_flutter_libs');
          }

          // Check for Hive usage
          if (fileName.contains('hive') ||
              fileContent.contains('HiveObject') ||
              fileContent.contains('Box<')) {
            configUsedPackages.add('hive');
            configUsedPackages.add('hive_flutter');
            configUsedPackages.add('hive_generator');
          }

          // Check for Drift usage
          if (fileName.contains('drift') ||
              fileName.contains('.drift.') ||
              fileContent.contains('@DriftDatabase')) {
            configUsedPackages.add('drift');
            configUsedPackages.add('drift_flutter');
            configUsedPackages.add('drift_dev');
          }
        }
      }
    }

    return configUsedPackages;
  }

  Future<void> checkPackages() async {
    print('\n${YELLOW}🔍 Checking for unused packages...${RESET}\n');

    unusedPackages.clear();
    packageUsage.clear();

    // Step 1: Parse pubspec.yaml to get all packages
    await parsePubspec();

    // Step 2: Scan all Dart files for imports
    final usedPackages = await scanForUsedPackages();

    // Step 2.5: Find packages used in pubspec.yaml configuration
    final configUsedPackages = await findPackagesUsedInConfig();
    usedPackages.addAll(configUsedPackages);

    // Step 3: Find unused packages
    for (final package in pubspecPackages.keys) {
      // Skip Flutter SDK and essential packages
      if (_isEssentialPackage(package)) {
        continue;
      }

      // Skip build tools and dev dependencies that don't need imports
      if (_isBuildTool(package)) {
        continue;
      }

      if (!usedPackages.contains(package)) {
        unusedPackages.add(package);
      }
    }

    // Display results
    if (unusedPackages.isEmpty) {
      print('${GREEN}✓ No unused packages found!${RESET}');
    } else {
      print('${RED}Found ${unusedPackages.length} unused packages:${RESET}\n');
      int index = 1;
      for (final package in unusedPackages) {
        print(
          '  ${RED}$index.${RESET} $package ${pubspecPackages[package] ?? ''}',
        );
        index++;
      }

      print('\n${CYAN}Tip: Use option 4 to remove these packages${RESET}');
    }

    // Also check for packages used but not in dependencies
    await checkMissingDependencies(usedPackages);
  }

  Future<void> parsePubspec() async {
    pubspecPackages.clear();

    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('${RED}Error: pubspec.yaml not found${RESET}');
      return;
    }

    final lines = await pubspecFile.readAsLines();
    bool inDependencies = false;
    bool inDevDependencies = false;

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Extract project name
      if (trimmedLine.startsWith('name:')) {
        projectName = trimmedLine.substring(5).trim();
        continue;
      }

      if (trimmedLine == 'dependencies:') {
        inDependencies = true;
        inDevDependencies = false;
        continue;
      }

      if (trimmedLine == 'dev_dependencies:') {
        inDevDependencies = true;
        inDependencies = false;
        continue;
      }

      // Check if we're leaving the dependencies section
      if ((inDependencies || inDevDependencies) &&
          line.isNotEmpty &&
          !line.startsWith(' ') &&
          !line.startsWith('\t')) {
        inDependencies = false;
        inDevDependencies = false;
      }

      // Parse package entries
      if ((inDependencies || inDevDependencies) &&
          trimmedLine.isNotEmpty &&
          !trimmedLine.startsWith('#')) {
        // Handle different formats: package: ^1.0.0 or package:
        final colonIndex = trimmedLine.indexOf(':');
        if (colonIndex > 0) {
          final packageName = trimmedLine.substring(0, colonIndex).trim();

          // Skip SDK references (flutter: sdk: flutter)
          if (packageName == 'sdk') {
            continue;
          }

          final version = colonIndex < trimmedLine.length - 1
              ? trimmedLine.substring(colonIndex + 1).trim()
              : '';

          // Skip if this is a SDK dependency marker
          if (version.trim() == 'sdk' || version.contains('sdk:')) {
            continue;
          }

          final section = inDevDependencies ? '(dev)' : '';
          pubspecPackages[packageName] = '$version $section';
        }
      }
    }

    print(
      '${CYAN}Found ${pubspecPackages.length} packages in pubspec.yaml${RESET}',
    );
  }

  Future<Set<String>> scanForUsedPackages() async {
    final usedPackages = <String>{};
    final libDir = Directory('lib');

    if (!libDir.existsSync()) {
      print('${RED}Error: lib directory not found${RESET}');
      return usedPackages;
    }

    // Also scan test directory if it exists
    final testDir = Directory('test');
    final directories = [libDir];
    if (testDir.existsSync()) {
      directories.add(testDir);
    }

    for (final dir in directories) {
      await for (final file in dir.list(recursive: true)) {
        if (file is File && file.path.endsWith('.dart')) {
          final content = await file.readAsString();

          // Find all import statements
          final importRegex = RegExp(
            r'''import\s+['"]package:([^/]+)/.*['"];''',
          );
          final matches = importRegex.allMatches(content);

          for (final match in matches) {
            final package = match.group(1);
            if (package != null) {
              usedPackages.add(package);

              // Track where each package is used
              packageUsage.putIfAbsent(package, () => []).add(file.path);
            }
          }
        }
      }
    }

    print(
      '${CYAN}Scanned ${directories.length} directories for imports${RESET}',
    );
    return usedPackages;
  }

  bool _isTransitiveDependency(String package) {
    // Common transitive dependencies that don't need to be explicitly listed
    const transitiveDeps = [
      // Sqflite transitive deps
      'sqflite_common',
      'sqflite_common_ffi',
      'sqflite_darwin',
      'sqflite_platform_interface',
      // Dio transitive deps
      'http_parser',
      'typed_data',
      // Flutter SDK packages
      'sky_engine',
      'flutter_web_plugins',
      // Common transitive deps
      'path_provider_platform_interface',
      'shared_preferences_platform_interface',
      'url_launcher_platform_interface',
      'package_info_plus_platform_interface',
      'plugin_platform_interface',
      'collection',
      'meta',
      'vector_math',
      'characters',
      'material_color_utilities',
      'leak_tracker',
      'leak_tracker_flutter_testing',
      'leak_tracker_testing',
      'vm_service',
      // BLoC transitive deps
      'bloc',
      'provider',
      'nested',
      // GetIt transitive deps
      'get_it_mixin',
      // Intl transitive deps
      'clock',
      // JSON serialization
      'json_annotation',
      // Other common transitive
      'args',
      'async',
      'boolean_selector',
      'matcher',
      'stack_trace',
      'stream_channel',
      'string_scanner',
      'term_glyph',
      'test_api',
      'source_span',
    ];
    return transitiveDeps.contains(package);
  }

  bool _isAssetFileGenerated(String filePath) {
    // Check if in generated directory
    final normalizedPath = filePath.replaceAll('/', Platform.pathSeparator);
    if (normalizedPath.contains(
      'lib${Platform.pathSeparator}generated${Platform.pathSeparator}',
    )) {
      return true;
    }

    // Check file content for generation markers
    final file = File(filePath);
    if (file.existsSync()) {
      try {
        final content = file.readAsStringSync();
        final generatedMarkers = [
          '/// GENERATED CODE - DO NOT MODIFY BY HAND',
          '///This file is automatically generated',
          'FlutterGen',
          '@GeneratedMicroModule',
          'DO NOT EDIT',
        ];

        for (final marker in generatedMarkers) {
          if (content.contains(marker)) {
            return true;
          }
        }
      } catch (e) {
        // If we can't read the file, assume it's not generated
        return false;
      }
    }

    return false;
  }

  Future<void> checkMissingDependencies(Set<String> usedPackages) async {
    final missingPackages = <String>[];

    for (final package in usedPackages) {
      // Skip Flutter SDK
      if (package == 'flutter') {
        continue;
      }

      // Skip the project's own package name
      if (package == projectName) {
        continue;
      }

      // Skip transitive dependencies
      if (_isTransitiveDependency(package)) {
        continue;
      }

      // Check if it's in pubspec.yaml
      if (!pubspecPackages.containsKey(package)) {
        missingPackages.add(package);
      }
    }

    if (missingPackages.isNotEmpty) {
      print('\n${YELLOW}⚠️  Packages used but not in pubspec.yaml:${RESET}');
      for (final package in missingPackages) {
        print('  ${YELLOW}•${RESET} $package');
        if (packageUsage[package] != null) {
          print('    Used in: ${packageUsage[package]!.first}');
        }
      }
    }
  }

  Future<void> checkAssets() async {
    print('\n${YELLOW}🔍 Checking for unused assets...${RESET}\n');

    unusedAssets.clear();

    // Get declared assets from pubspec.yaml
    final declaredAssets = await getDeclaredAssets();
    if (declaredAssets.isEmpty) {
      print('${CYAN}No assets declared in pubspec.yaml${RESET}');
      return;
    }

    print('${CYAN}Found ${declaredAssets.length} declared assets${RESET}');

    // Parse constants from generated files FIRST
    final constantToAsset = await parseAssetConstants();
    print(
      '${CYAN}Found ${constantToAsset.length} asset constants in generated files${RESET}',
    );

    // Find used assets in code
    final usedAssets = await findUsedAssets();
    print('${CYAN}Found ${usedAssets.length} asset references in code${RESET}');

    // Find framework-managed assets (EasyLocalization, etc.)
    final frameworkAssets = await findFrameworkAssets();
    if (frameworkAssets.isNotEmpty) {
      print(
        '${CYAN}Found ${frameworkAssets.length} framework-managed assets${RESET}',
      );
      usedAssets.addAll(frameworkAssets);
    }

    // Find unused assets
    for (final asset in declaredAssets) {
      bool isUsed = false;

      // Check if the asset or any parent directory is referenced
      for (final usedAsset in usedAssets) {
        if (asset.contains(usedAsset) ||
            usedAsset.contains(asset) ||
            asset.split('/').last == usedAsset.split('/').last) {
          isUsed = true;
          break;
        }
      }

      if (!isUsed) {
        // Check if file actually exists before marking as unused
        final assetFile = File(asset);
        if (assetFile.existsSync()) {
          unusedAssets.add(asset);
        }
      }
    }

    // Separate manual and generated assets
    final manualUnusedAssets = <String>[];
    final generatedUnusedAssets = <String, AssetInfo>{}; // asset -> AssetInfo

    for (final asset in unusedAssets) {
      AssetInfo? matchingInfo;

      // Check if this asset comes from a generated file
      for (final assetInfo in constantToAsset.values) {
        if (assetInfo.path == asset && assetInfo.isGenerated) {
          matchingInfo = assetInfo;
          break;
        }
      }

      if (matchingInfo != null) {
        generatedUnusedAssets[asset] = matchingInfo;
      } else {
        manualUnusedAssets.add(asset);
      }
    }

    // Display results
    print('\n${BOLD}━━━ Asset Cleanup Results ━━━${RESET}\n');

    // Show manual assets
    if (manualUnusedAssets.isEmpty) {
      print('${GREEN}✓ No unused manual assets found!${RESET}');
    } else {
      print(
        '${RED}Found ${manualUnusedAssets.length} unused manual assets:${RESET}\n',
      );

      int totalSize = 0;
      for (final asset in manualUnusedAssets) {
        final file = File(asset);
        if (file.existsSync()) {
          final size = file.lengthSync();
          totalSize += size;
          final sizeKB = (size / 1024).toStringAsFixed(1);
          print('  ${RED}•${RESET} $asset (${sizeKB}KB)');
        }
      }

      final totalSizeMB = (totalSize / 1024 / 1024).toStringAsFixed(2);
      print('\n  ${YELLOW}Total space: ${totalSizeMB} MB${RESET}');
    }

    // Show generated assets with enhanced info
    if (generatedUnusedAssets.isNotEmpty) {
      print(
        '\n${YELLOW}━━━ Generated Assets (⚠️  Review Before Removing) ━━━${RESET}\n',
      );
      print(
        '${YELLOW}⚠️  Found ${generatedUnusedAssets.length} unused assets in generated files:${RESET}\n',
      );

      int totalSize = 0;
      for (final entry in generatedUnusedAssets.entries) {
        final asset = entry.key;
        final assetInfo = entry.value;
        final file = File(asset);
        if (file.existsSync()) {
          final size = file.lengthSync();
          totalSize += size;
          final sizeKB = (size / 1024).toStringAsFixed(1);
          print('  ${YELLOW}⚠${RESET} $asset (${sizeKB}KB)');
          if (assetInfo.fullAccessorPath != null) {
            print('     Accessor: ${CYAN}${assetInfo.fullAccessorPath}${RESET}');
          }
          print('     From: ${CYAN}${assetInfo.sourceFile}${RESET}');
        }
      }

      final totalSizeMB = (totalSize / 1024 / 1024).toStringAsFixed(2);
      print('\n  ${YELLOW}Total space: ${totalSizeMB} MB${RESET}');
      print(
        '\n  ${YELLOW}⚠️  WARNING: These assets are defined in generated files.${RESET}',
      );
      print(
        '     ${YELLOW}The constants exist but are never used in your code.${RESET}',
      );
      print(
        '     ${YELLOW}After removing, regenerate with: flutter packages pub run build_runner build${RESET}',
      );
    }

    if (manualUnusedAssets.isNotEmpty || generatedUnusedAssets.isNotEmpty) {
      print('\n${CYAN}Use option 5 to remove these assets${RESET}');
    }
  }

  Future<Set<String>> findFrameworkAssets() async {
    final frameworkAssets = <String>{};
    final libDir = Directory('lib');

    if (!libDir.existsSync()) {
      return frameworkAssets;
    }

    await for (final file in libDir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = await file.readAsString();

        // Pattern 1: EasyLocalization path configuration
        // EasyLocalization(path: 'translations', ...)
        final easyLocPattern = RegExp(
          r'''EasyLocalization\s*\([^)]*path:\s*['"]([^'"]+)['"]''',
          multiLine: true,
          dotAll: true,
        );
        for (final match in easyLocPattern.allMatches(content)) {
          final path = match.group(1);
          if (path != null) {
            // Add all files from this directory
            final dir = Directory(path);
            if (dir.existsSync()) {
              await for (final assetFile in dir.list(recursive: true)) {
                if (assetFile is File) {
                  frameworkAssets.add(assetFile.path.replaceAll('\\', '/'));
                }
              }
            }
          }
        }

        // Pattern 2: Translation method usage (.tr() or context.tr())
        // If translations are being used, mark translation directories as used
        if (content.contains('.tr()') || content.contains('context.tr(')) {
          // Check for translation directories
          for (final dirName in ['translations', 'locales', 'i18n', 'lang']) {
            final dir = Directory(dirName);
            if (dir.existsSync()) {
              await for (final assetFile in dir.list(recursive: true)) {
                if (assetFile is File) {
                  frameworkAssets.add(assetFile.path.replaceAll('\\', '/'));
                }
              }
            }
          }
        }

        // Pattern 3: Firebase Remote Config
        final firebaseConfigPattern = RegExp(
          r'''RemoteConfig\s*\([^)]*defaults:\s*['"]([^'"]+)['"]''',
        );
        for (final match in firebaseConfigPattern.allMatches(content)) {
          final path = match.group(1);
          if (path != null) {
            frameworkAssets.add(path);
          }
        }
      }
    }

    return frameworkAssets;
  }

  Future<Set<String>> getDeclaredAssets() async {
    final assets = <String>{};
    final pubspecFile = File('pubspec.yaml');

    if (!pubspecFile.existsSync()) {
      return assets;
    }

    final content = await pubspecFile.readAsString();
    final lines = content.split('\n');

    bool inAssetsSection = false;
    int assetIndentLevel = -1;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trim();

      // Check if we're entering the assets section
      if (trimmedLine == 'assets:') {
        inAssetsSection = true;
        assetIndentLevel = line.indexOf('assets:');
        continue;
      }

      // Check if we're in assets section
      if (inAssetsSection) {
        // Check if we're leaving the assets section
        if (line.isNotEmpty &&
            !line.startsWith(' ' * (assetIndentLevel + 2)) &&
            !line.startsWith('\t')) {
          if (line.trim().isNotEmpty && !line.trim().startsWith('#')) {
            inAssetsSection = false;
            continue;
          }
        }

        // Parse asset entry
        if (trimmedLine.startsWith('- ')) {
          var assetPath = trimmedLine.substring(2).trim();

          // Remove any trailing comments
          final commentIndex = assetPath.indexOf('#');
          if (commentIndex > 0) {
            assetPath = assetPath.substring(0, commentIndex).trim();
          }

          if (assetPath.isNotEmpty) {
            // If it's a directory, add all files in it
            if (assetPath.endsWith('/')) {
              final dir = Directory(assetPath);
              if (dir.existsSync()) {
                await for (final file in dir.list(recursive: true)) {
                  if (file is File) {
                    assets.add(file.path.replaceAll('\\', '/'));
                  }
                }
              }
            } else {
              assets.add(assetPath);
            }
          }
        }
      }
    }

    return assets;
  }

  Future<Map<String, AssetInfo>> parseAssetConstants() async {
    final constantToAsset = <String, AssetInfo>{};

    // Common locations for asset constant files
    final possiblePaths = [
      'lib/generated/assets.dart',
      'lib/generated/assets.gen.dart',
      'lib/gen/assets.gen.dart',
      'lib/core/constants/assets.dart',
      'lib/constants/assets.dart',
      'lib/utils/assets.dart',
      'lib/common/assets.dart',
    ];

    for (final path in possiblePaths) {
      final file = File(path);
      if (!file.existsSync()) {
        continue;
      }

      final isGenerated = _isAssetFileGenerated(path);
      final content = await file.readAsString();
      final lines = content.split('\n');

      String? currentClass;
      String? currentCategory;

      // Pattern to detect class definitions like: class $AssetsIconsGen
      final classPattern = RegExp(r'class\s+\$Assets(\w+)Gen\s*\{');

      // Pattern 1: static const String constantName = 'asset/path';
      final constantPattern = RegExp(
        r'''static\s+const\s+String\s+(\w+)\s*=\s*['"]([^'"]+)['"]''',
      );

      // Pattern 2: String/AssetGenImage get constantName => 'asset/path' or => const AssetGenImage('asset/path');
      final getterPattern = RegExp(
        r'''(?:AssetGenImage|String)\s+get\s+(\w+)\s*=>.*?['"]([^'"]+)['"]''',
      );

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        final trimmedLine = line.trim();

        // Detect class definition
        final classMatch = classPattern.firstMatch(trimmedLine);
        if (classMatch != null) {
          final categoryName = classMatch.group(1);
          if (categoryName != null) {
            currentClass = '\$Assets${categoryName}Gen';
            // Convert class name to category: IconsGen -> icons, ImagesGen -> images
            currentCategory = categoryName.toLowerCase();
          }
          continue;
        }

        // Reset when leaving a class
        if (trimmedLine == '}' && currentClass != null) {
          currentClass = null;
          currentCategory = null;
          continue;
        }

        // Check for simple constants
        var match = constantPattern.firstMatch(trimmedLine);
        if (match != null) {
          final constantName = match.group(1);
          final assetPath = match.group(2);
          if (constantName != null && assetPath != null) {
            final fullPath = currentCategory != null
                ? 'Assets.$currentCategory.$constantName'
                : 'Assets.$constantName';

            constantToAsset[constantName] = AssetInfo(
              path: assetPath,
              isGenerated: isGenerated,
              sourceFile: path,
              constantName: constantName,
              category: currentCategory,
              fullAccessorPath: fullPath,
            );
          }
          continue;
        }

        // Check for getters
        match = getterPattern.firstMatch(trimmedLine);
        if (match != null) {
          final getterName = match.group(1);
          final assetPath = match.group(2);
          if (getterName != null && assetPath != null) {
            final fullPath = currentCategory != null
                ? 'Assets.$currentCategory.$getterName'
                : 'Assets.$getterName';

            constantToAsset[getterName] = AssetInfo(
              path: assetPath,
              isGenerated: isGenerated,
              sourceFile: path,
              constantName: getterName,
              getterChain: getterName,
              category: currentCategory,
              fullAccessorPath: fullPath,
            );
          }
        }
      }
    }

    return constantToAsset;
  }

  Future<Set<String>> findUsedAssetConstants(
    Map<String, AssetInfo> constantToAsset,
  ) async {
    final usedConstants = <String>{};
    final libDir = Directory('lib');

    if (!libDir.existsSync()) {
      return usedConstants;
    }

    // Get the assets file paths to exclude them
    final assetsFilePaths = [
      'lib${Platform.pathSeparator}generated${Platform.pathSeparator}assets.dart',
      'lib${Platform.pathSeparator}generated${Platform.pathSeparator}assets.gen.dart',
      'lib${Platform.pathSeparator}gen${Platform.pathSeparator}assets.gen.dart',
      'lib${Platform.pathSeparator}core${Platform.pathSeparator}constants${Platform.pathSeparator}assets.dart',
      'lib${Platform.pathSeparator}constants${Platform.pathSeparator}assets.dart',
    ];

    await for (final file in libDir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        // Skip the assets constants files themselves
        final normalizedPath = file.path.replaceAll(
          '/',
          Platform.pathSeparator,
        );
        bool isAssetsFile = false;
        for (final assetsPath in assetsFilePaths) {
          if (normalizedPath.endsWith(assetsPath)) {
            isAssetsFile = true;
            break;
          }
        }

        if (isAssetsFile) {
          continue;
        }

        final content = await file.readAsString();

        // Check for usage of each constant/getter
        for (final entry in constantToAsset.entries) {
          final constantName = entry.key;
          final assetInfo = entry.value;

          bool isUsed = false;

          // Pattern 1: Check for full accessor path (e.g., Assets.icons.alarm)
          if (assetInfo.fullAccessorPath != null &&
              content.contains(assetInfo.fullAccessorPath!)) {
            isUsed = true;
          }

          // Pattern 2: Check for method chaining on the constant
          // e.g., Assets.icons.alarm.image() or Assets.icons.alarm.provider()
          if (!isUsed && assetInfo.fullAccessorPath != null) {
            final methodPatterns = [
              '${assetInfo.fullAccessorPath}.image(',
              '${assetInfo.fullAccessorPath}.provider(',
              '${assetInfo.fullAccessorPath}.path',
              '${assetInfo.fullAccessorPath}.keyName',
            ];

            for (final pattern in methodPatterns) {
              if (content.contains(pattern)) {
                isUsed = true;
                break;
              }
            }
          }

          // Pattern 3: Check for direct Assets.constantName usage (for non-nested constants)
          if (!isUsed && content.contains('Assets.$constantName')) {
            isUsed = true;
          }

          // Pattern 4: Check for asset path string (check BOTH with quotes and asset string)
          if (!isUsed) {
            final assetPath = assetInfo.path;
            if (content.contains("'$assetPath'") ||
                content.contains('"$assetPath"')) {
              isUsed = true;
            }
          }

          // Pattern 5: Standalone usage with word boundaries (as final fallback)
          // Only check if constant name is reasonably unique (longer than 3 chars)
          if (!isUsed && constantName.length > 3) {
            final pattern = RegExp('\\b$constantName\\b');
            if (pattern.hasMatch(content)) {
              isUsed = true;
            }
          }

          if (isUsed) {
            usedConstants.add(constantName);
          }
        }
      }
    }

    return usedConstants;
  }

  Future<Set<String>> findUsedAssets() async {
    final usedAssets = <String>{};
    final libDir = Directory('lib');

    if (!libDir.existsSync()) {
      return usedAssets;
    }

    // First, check for asset constants and their usage
    final constantToAsset = await parseAssetConstants();
    final usedConstants = await findUsedAssetConstants(constantToAsset);

    // Add assets from used constants
    for (final constantName in usedConstants) {
      final assetInfo = constantToAsset[constantName];
      if (assetInfo != null) {
        usedAssets.add(assetInfo.path);
      }
    }

    print(
      '${CYAN}Found ${usedConstants.length} used asset constants out of ${constantToAsset.length}${RESET}',
    );

    // Also scan for direct asset references (not through constants)
    final assetsFilePaths = [
      'lib${Platform.pathSeparator}generated${Platform.pathSeparator}assets.dart',
      'lib${Platform.pathSeparator}generated${Platform.pathSeparator}assets.gen.dart',
      'lib${Platform.pathSeparator}gen${Platform.pathSeparator}assets.gen.dart',
      'lib${Platform.pathSeparator}core${Platform.pathSeparator}constants${Platform.pathSeparator}assets.dart',
      'lib${Platform.pathSeparator}constants${Platform.pathSeparator}assets.dart',
    ];

    await for (final file in libDir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        // Skip the assets constants file itself
        final normalizedPath = file.path.replaceAll(
          '/',
          Platform.pathSeparator,
        );
        bool isAssetsFile = false;
        for (final assetsPath in assetsFilePaths) {
          if (normalizedPath.endsWith(assetsPath)) {
            isAssetsFile = true;
            break;
          }
        }

        if (isAssetsFile) {
          continue;
        }

        final content = await file.readAsString();

        // Various patterns to find asset references
        // Pattern 1: Direct string references to common asset files
        final assetExtensions = [
          'png',
          'jpg',
          'jpeg',
          'gif',
          'svg',
          'json',
          'txt',
          'pdf',
          'webp',
          'mp3',
          'wav',
          'mp4',
          'ttf',
          'otf',
          'xml',
          'yaml',
        ];

        for (final ext in assetExtensions) {
          final pattern = RegExp('[\'"]([^\'"/]*\.$ext)[\'"]');
          for (final match in pattern.allMatches(content)) {
            final asset = match.group(1);
            if (asset != null) {
              usedAssets.add(asset);
              // Also add with common paths
              usedAssets.add('assets/$asset');
              usedAssets.add('assets/images/$asset');
              usedAssets.add('assets/icons/$asset');
            }
          }
        }

        // Pattern 2: AssetImage references
        final assetImagePattern = RegExp(r'''AssetImage\(['"]([^'"]+)['"]''');
        for (final match in assetImagePattern.allMatches(content)) {
          final asset = match.group(1);
          if (asset != null) usedAssets.add(asset);
        }

        // Pattern 3: Image.asset references
        final imageAssetPattern = RegExp(r'''Image\.asset\(['"]([^'"]+)['"]''');
        for (final match in imageAssetPattern.allMatches(content)) {
          final asset = match.group(1);
          if (asset != null) usedAssets.add(asset);
        }

        // Pattern 4: rootBundle references
        final bundlePattern = RegExp(r'''rootBundle\.\w+\(['"]([^'"]+)['"]''');
        for (final match in bundlePattern.allMatches(content)) {
          final asset = match.group(1);
          if (asset != null) usedAssets.add(asset);
        }

        // Pattern 5: Generic asset path pattern
        final pathPattern = RegExp(r'''['"]assets/[^'"]+['"]''');
        for (final match in pathPattern.allMatches(content)) {
          var asset = match.group(0);
          if (asset != null) {
            asset = asset.substring(1, asset.length - 1); // Remove quotes
            usedAssets.add(asset);
          }
        }
      }
    }

    return usedAssets;
  }

  Future<void> checkAll() async {
    print('\n${YELLOW}🔍 Running complete check...${RESET}\n');

    print('${CYAN}═══ Step 1/2: Checking packages ═══${RESET}');
    await checkPackages();

    print('\n${CYAN}═══ Step 2/2: Checking assets ═══${RESET}');
    await checkAssets();

    // Summary
    print('\n${BOLD}📊 Summary:${RESET}');
    print('  Unused packages: ${unusedPackages.length}');
    print('  Unused assets: ${unusedAssets.length}');

    if (unusedPackages.isNotEmpty || unusedAssets.isNotEmpty) {
      print('\n${YELLOW}Use options 4-6 to clean up${RESET}');
    } else {
      print('\n${GREEN}🎉 Your project is clean!${RESET}');
    }
  }

  Future<void> removePackages() async {
    if (unusedPackages.isEmpty) {
      print('\n${YELLOW}Checking for unused packages first...${RESET}');
      await checkPackages();
    }

    if (unusedPackages.isEmpty) {
      print('\n${GREEN}No unused packages to remove!${RESET}');
      return;
    }

    print('\n${RED}The following packages will be removed:${RESET}');
    for (final package in unusedPackages) {
      print('  ${RED}•${RESET} $package');
    }

    stdout.write('\n${BOLD}Remove these packages? (y/n): ${RESET}');
    final confirm = stdin.readLineSync();

    if (confirm?.toLowerCase() != 'y') {
      print('${YELLOW}Cancelled${RESET}');
      return;
    }

    // Remove packages from pubspec.yaml
    final pubspecFile = File('pubspec.yaml');
    final lines = await pubspecFile.readAsLines();
    final newLines = <String>[];

    for (final line in lines) {
      bool shouldKeep = true;

      for (final package in unusedPackages) {
        if (line.trim().startsWith('$package:')) {
          shouldKeep = false;
          print('  ${RED}✗${RESET} Removed $package');
          break;
        }
      }

      if (shouldKeep) {
        newLines.add(line);
      }
    }

    // Write back
    await pubspecFile.writeAsString(newLines.join('\n'));

    print('\n${GREEN}✓ Packages removed from pubspec.yaml${RESET}');
    print('${CYAN}Run "flutter pub get" to update dependencies${RESET}');
  }

  Future<void> removeAssets() async {
    if (unusedAssets.isEmpty) {
      print('\n${YELLOW}Checking for unused assets first...${RESET}');
      await checkAssets();
    }

    if (unusedAssets.isEmpty) {
      print('\n${GREEN}No unused assets to remove!${RESET}');
      return;
    }

    // Separate manual and generated assets
    final constantToAsset = await parseAssetConstants();
    final manualAssets = <String>[];
    final generatedAssets = <String>[];

    for (final asset in unusedAssets) {
      bool isGenerated = false;

      // Check if this asset comes from a generated file
      for (final assetInfo in constantToAsset.values) {
        if (assetInfo.path == asset && assetInfo.isGenerated) {
          isGenerated = true;
          break;
        }
      }

      if (isGenerated) {
        generatedAssets.add(asset);
      } else {
        manualAssets.add(asset);
      }
    }

    final assetsToDelete = <String>[];

    // Handle manual assets
    if (manualAssets.isNotEmpty) {
      print(
        '\n${RED}━━━ Manual Assets to Remove (${manualAssets.length}) ━━━${RESET}',
      );
      int totalSize = 0;
      for (final asset in manualAssets) {
        final file = File(asset);
        if (file.existsSync()) {
          final size = file.lengthSync();
          totalSize += size;
          print(
            '  ${RED}•${RESET} $asset (${(size / 1024).toStringAsFixed(1)}KB)',
          );
        }
      }

      final totalSizeMB = (totalSize / 1024 / 1024).toStringAsFixed(2);
      print('  ${YELLOW}Total space: ${totalSizeMB} MB${RESET}');

      stdout.write('\n${BOLD}Delete manual assets? (y/n): ${RESET}');
      final confirm = stdin.readLineSync();

      if (confirm?.toLowerCase() == 'y') {
        assetsToDelete.addAll(manualAssets);
      } else {
        print('${YELLOW}Skipped manual assets${RESET}');
      }
    }

    // Handle generated assets
    if (generatedAssets.isNotEmpty) {
      print(
        '\n${YELLOW}━━━ Generated Assets to Remove (${generatedAssets.length}) ━━━${RESET}',
      );
      int totalSize = 0;
      for (final asset in generatedAssets) {
        final file = File(asset);
        if (file.existsSync()) {
          final size = file.lengthSync();
          totalSize += size;
          print(
            '  ${YELLOW}⚠${RESET} $asset (${(size / 1024).toStringAsFixed(1)}KB)',
          );
        }
      }

      final totalSizeMB = (totalSize / 1024 / 1024).toStringAsFixed(2);
      print('  ${YELLOW}Total space: ${totalSizeMB} MB${RESET}');

      print(
        '\n${YELLOW}⚠️  WARNING: These are auto-generated by flutter_gen.${RESET}',
      );
      print(
        '   ${YELLOW}Constants will exist until you run: flutter packages pub run build_runner build${RESET}',
      );

      stdout.write(
        '\n${BOLD}${YELLOW}Delete generated assets too? (y/n): ${RESET}',
      );
      final confirm = stdin.readLineSync();

      if (confirm?.toLowerCase() == 'y') {
        assetsToDelete.addAll(generatedAssets);
      } else {
        print('${YELLOW}Skipped generated assets${RESET}');
      }
    }

    if (assetsToDelete.isEmpty) {
      print('\n${YELLOW}No assets selected for deletion${RESET}');
      return;
    }

    // Delete files
    print('\n${CYAN}Deleting files...${RESET}');
    int deletedCount = 0;
    for (final asset in assetsToDelete) {
      final file = File(asset);
      if (file.existsSync()) {
        try {
          await file.delete();
          print('  ${RED}✗${RESET} Deleted $asset');
          deletedCount++;
        } catch (e) {
          print('  ${YELLOW}⚠${RESET} Could not delete $asset: $e');
        }
      }
    }

    // Remove from pubspec.yaml
    print('\n${CYAN}Updating pubspec.yaml...${RESET}');
    final pubspecFile = File('pubspec.yaml');
    final lines = await pubspecFile.readAsLines();
    final newLines = <String>[];

    for (final line in lines) {
      bool shouldKeep = true;

      for (final asset in assetsToDelete) {
        if (line.contains(asset)) {
          shouldKeep = false;
          break;
        }
      }

      if (shouldKeep) {
        newLines.add(line);
      }
    }

    await pubspecFile.writeAsString(newLines.join('\n'));

    print('\n${GREEN}✓ Deleted $deletedCount assets${RESET}');
    print('${GREEN}✓ Updated pubspec.yaml${RESET}');

    // Show post-deletion guidance if generated assets were deleted
    if (generatedAssets.any((asset) => assetsToDelete.contains(asset))) {
      print('\n${CYAN}📌 Next Steps:${RESET}');
      print(
        '   ${CYAN}Run: flutter packages pub run build_runner build${RESET}',
      );
      print(
        '   ${CYAN}This will regenerate asset files without deleted assets${RESET}',
      );
    }
  }

  Future<void> quickCleanup() async {
    print('\n${YELLOW}⚡ Quick Cleanup - This will:${RESET}');
    print('  1. Find all unused packages and assets');
    print('  2. Remove them automatically');
    print('  3. Clean up your project');

    stdout.write('\n${BOLD}${RED}Continue? (y/n): ${RESET}');
    final confirm = stdin.readLineSync();

    if (confirm?.toLowerCase() != 'y') {
      print('${YELLOW}Cancelled${RESET}');
      return;
    }

    // Check everything
    print('\n${CYAN}Analyzing project...${RESET}');
    await checkPackages();
    await checkAssets();

    // Remove unused items
    if (unusedPackages.isNotEmpty) {
      print(
        '\n${YELLOW}Removing ${unusedPackages.length} unused packages...${RESET}',
      );

      final pubspecFile = File('pubspec.yaml');
      final lines = await pubspecFile.readAsLines();
      final newLines = <String>[];

      for (final line in lines) {
        bool shouldKeep = true;

        for (final package in unusedPackages) {
          if (line.trim().startsWith('$package:')) {
            shouldKeep = false;
            print('  ${RED}✗${RESET} Removed $package');
            break;
          }
        }

        if (shouldKeep) {
          newLines.add(line);
        }
      }

      await pubspecFile.writeAsString(newLines.join('\n'));
    }

    if (unusedAssets.isNotEmpty) {
      print(
        '\n${YELLOW}Removing ${unusedAssets.length} unused assets...${RESET}',
      );

      for (final asset in unusedAssets) {
        final file = File(asset);
        if (file.existsSync()) {
          try {
            await file.delete();
            print('  ${RED}✗${RESET} Deleted $asset');
          } catch (e) {
            print('  ${YELLOW}⚠${RESET} Could not delete $asset');
          }
        }
      }
    }

    print('\n${GREEN}✨ Quick cleanup complete!${RESET}');
    print('${CYAN}Run "flutter clean && flutter pub get" to finalize${RESET}');
  }

  Future<void> waitForUser() async {
    print('\n${CYAN}Press Enter to continue...${RESET}');
    // Ensure stdin is in line mode for proper input handling
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = true;
      }
      stdin.readLineSync();
      // Input read successfully
    } catch (e) {
      // If stdin reading fails, just wait briefly
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}

void main() async {
  // Check if we're in a Flutter project
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('\x1B[31mError: pubspec.yaml not found!\x1B[0m');
    print(
      'Make sure you run this script from your Flutter project root directory.',
    );
    exit(1);
  }

  try {
    final cleanup = FlutterCleanup();
    await cleanup.run();
  } catch (e, stackTrace) {
    print('\x1B[31mError: $e\x1B[0m');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}
