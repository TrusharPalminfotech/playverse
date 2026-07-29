# SonarCloud Integration - PlayVerse Flutter CI/CD

This document details how SonarCloud is integrated into the PlayVerse Flutter application, how code coverage is generated, and how the CI/CD pipelines operate.

---

## Local Development Commands

To run quality checks locally, execute the following commands in the project root:

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run code generation (required for Mockito mocks)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Perform static code analysis (Dart lints and compile checks)
flutter analyze

# 4. Run tests and generate local coverage reports (lcov.info)
flutter test --coverage

# 5. Run the SonarQube / SonarCloud Scanner
sonar-scanner
```

---

## Local Coverage Generation

Running `flutter test --coverage` automatically writes test coverage records to:
- `coverage/lcov.info`

SonarCloud is configured to read this file during analysis via the property settings:
- `sonar.dart.lcov.reportPaths=coverage/lcov.info`
- `sonar.flutter.coverage.reportPath=coverage/lcov.info`
- `sonar.dart.lcov.reportPath=coverage/lcov.info`

To inspect the coverage report visually as an HTML page, you can install the `lcov` tool (e.g. `brew install lcov` on macOS) and generate HTML pages:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Build Runner & Git Strategy
- **Current Strategy**: Generated mock files (`*.mocks.dart`) and auto-generated build outputs are **NOT** committed to Git (keeping the repository clean and avoiding code bloat).
- **CI/CD Impact**: Because generated mock code is not checked in, the CI pipeline **must** execute `flutter pub run build_runner build --delete-conflicting-outputs` before running analysis (`flutter analyze`) and tests (`flutter test`). If generated files were checked into Git, this build runner step could be skipped to save build time.

---

## Security & Token Authentication
- **Token Security**: Authentication is handled dynamically by GitHub Actions using the `SONAR_TOKEN` repository secret. 
- **Important Constraint**: Therefore, the properties file `sonar-project.properties` must **never** contain the `sonar.login` or `sonar.token` key value hardcoded. This eliminates security risks in public repositories.

---

## Configuring SonarCloud Server

1. Log in to your SonarCloud account.
2. Select your organization and create a new project named `Playverse` (with Project Key `Playverse`).
3. Generate a **Project Token** (set as `SONAR_TOKEN` in GitHub secrets).
4. Configure the **Quality Gate** rules on the SonarCloud console to require:
   - **Bugs**: 0
   - **Vulnerabilities**: 0
   - **Security Hotspots**: 0 pending review
   - **Coverage**: >= 80%
   - **Duplicated Lines**: < 3%
   - **Maintainability Rating**: A
   - **Reliability Rating**: A

---

## How GitHub Actions Works

The SonarCloud analysis is integrated directly into the `.github/workflows/ios-ci.yml` pipeline:

1. **Triggers**: Executes on pushes to `ios-app`, `main`, and `develop`, and on all pull requests targeting `main` and `develop`.
2. **Steps Execution**:
   - **Checkout**: Pulls the repository with `fetch-depth: 0` so the Sonar scanner has history logs for Git Blame tracking and PR differential analysis.
   - **Setup Java & Flutter**: Sets up dependencies and caches to ensure fast runner speeds.
   - **Dependency fetching & generation**: Runs `flutter pub get` and `build_runner` to rebuild the mock files.
   - **Flutter Analyze**: Executes code style checks (fails if errors are found).
   - **Flutter Test with Coverage**: Runs tests and outputs `coverage/lcov.info` file.
   - **Coverage Verification**: Verifies `coverage/lcov.info` exists and immediately fails the build if missing.
   - **Coverage Artifact Upload**: Uploads the `coverage` directory to the job artifacts for developer download and debugging.
   - **SonarCloud Scan**: Invokes the pinned stable `sonarsource/sonarqube-scan-action@v6` scanner, sending code statistics and test coverage to SonarCloud.
   - **Quality Gate Check**: Utilizes pinned stable `sonarsource/sonarqube-quality-gate-action@v1` to poll the server. If the Quality Gate fails, the workflow terminates, failing the build and blocking deployment.
   - **iOS Compilation & TestFlight**: Runs conditionally `if: github.event_name == 'push' && github.ref_name == 'ios-app'` to compile and upload the IPA to Apple TestFlight.

---

## Environment Variables / GitHub Secrets

To connect to your SonarCloud server from GitHub Actions, configure the following secrets in **Repository Settings -> Secrets and Variables -> Actions**:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `SONAR_TOKEN` | Generated SonarCloud project analysis token | `sqp_xxxxxxx...` |

---

## Troubleshooting & Common Errors

### 1. `Cannot hit test on the specified widget` / Viewport warnings
- **Issue**: Widget test actions like `tap` fail due to widgets rendering outside the default 800x600 test screen size.
- **Solution**: Ensure your widget tests call `configureViewSize(tester)` at the start of each execution block to establish a larger virtual window size (e.g., 1200x1000).

### 2. `A Timer is still pending even after the widget tree was disposed`
- **Issue**: Async operations (like mock authentication or login delays) are scheduled via `Future.delayed` but don't complete before the test ends.
- **Solution**: Run `await tester.pumpAndSettle();` at the end of the test to allow all timers to complete.

### 3. `SonarQube Scan fails: No lcov report found`
- **Issue**: SonarQube runs before `flutter test --coverage` completes or can't locate the file.
- **Solution**: The pipeline verifies files exist before execution. Check local test execution logs if issues persist.
