# Contributing to Flutter Scan and Fill Form

Thank you for considering contributing to this project! We welcome contributions from the community.

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists in the [Issues](https://github.com/aiqs4/flutter-scan-and-fill-form/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Screenshots if applicable
   - Device/OS information

### Submitting Changes

1. **Fork the Repository**
   ```bash
   git clone https://github.com/aiqs4/flutter-scan-and-fill-form.git
   cd flutter-scan-and-fill-form
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Write clear commit messages
   - Add tests if applicable
   - Update documentation

4. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Describe your changes
   - Link related issues

## Code Style Guidelines

### Dart/Flutter

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format code
- Run `flutter analyze` to check for issues
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages

Use conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(ocr): add support for multiple languages
fix(camera): resolve permission request crash on Android
docs(readme): update installation instructions
```

## Development Setup

1. **Prerequisites**
   - Flutter SDK (3.0.0+)
   - Android Studio or VS Code
   - Git

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Run Tests**
   ```bash
   flutter test
   ```

5. **Check Code Quality**
   ```bash
   flutter analyze
   dart format .
   ```

## Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for complete flows
- Ensure all tests pass before submitting PR
- Aim for good test coverage

## Documentation

- Update README.md for user-facing changes
- Update ARCHITECTURE.md for design changes
- Add inline comments for complex code
- Update CHANGELOG.md with your changes

## Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Your contribution will be credited

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

## Questions?

Feel free to:
- Open an issue for questions
- Join discussions in existing issues
- Reach out to maintainers

## Recognition

Contributors will be:
- Listed in the project's contributors
- Mentioned in release notes
- Credited in the README

Thank you for contributing! 🎉
