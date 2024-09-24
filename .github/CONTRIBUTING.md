# Contributing to Decentralized Marketplace on Stacks

Thank you for your interest in contributing to the Decentralized Marketplace on Stacks! We welcome contributions from everyone. By contributing to this project, you agree to abide by the guidelines and principles set forth below to ensure a smooth collaboration and high-quality code.

## How to Contribute

### 1. Getting Started

1. **Fork the repository**:
   - Start by [forking the repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo) to your GitHub account.
2. **Clone your fork**:

   - Clone the forked repository to your local machine:
     ```bash
     git clone https://github.com/your-username/decentralized-marketplace.git
     cd decentralized-marketplace
     ```

3. **Install dependencies**:

   - Install the necessary dependencies:
     ```bash
     npm install
     ```

4. **Set up feature branch**:
   - Create a new branch for your contribution:
     ```bash
     git checkout -b feat/your-feature
     ```

### 2. Development Workflow

1. **Add your changes**:
   - Make your changes, ensuring your code is clean and readable.
2. **Write or Update Tests**:

   - Ensure that each feature you develop is covered by test cases.
   - Add tests in the relevant `tests/` directory for the contract you're modifying.

3. **Run tests**:

   - Before submitting your changes, ensure all tests pass:
     ```bash
     clarity test contracts/MarketplaceContract/tests/test-marketplace.clar
     ```

4. **Commit your changes**:

   - Make clear, concise commit messages that explain what you've done.
     ```bash
     git commit -m "Add auction feature to marketplace contract"
     ```

5. **Push your branch**:

   - Push your feature branch to your fork:
     ```bash
     git push origin feat/your-feature
     ```

6. **Submit a Pull Request (PR)**:
   - Once your changes are ready, [open a pull request](https://docs.github.com/en/pull-requests) from your fork to the main repository.
   - Provide a detailed description of your changes in the PR to help reviewers understand the context of your contribution.

### 3. Code of Conduct

Please ensure your contributions follow our code of conduct:

- Be respectful of other contributors.
- Provide constructive feedback and be open to receiving the same.
- Ensure your contributions do not negatively affect existing functionality.

### 4. Code Guidelines

1. **Code Style**:
   - Follow consistent formatting and indentation for Clarity and JavaScript code.
   - Use meaningful variable and function names.
2. **Comments**:
   - Comment your code where necessary, especially in complex sections or critical logic paths.
3. **Modular Design**:
   - Keep your code modular and extensible, avoiding tight coupling between contracts and functions.

### 5. Feature Branch Naming Convention

Feature branches should follow this naming convention for easy tracking:

```plaintext
feat/<feature-name>
```

For bug fixes, use:

```plaintext
fix/<issue-description>
```

### 6. Reviewing Process

- Once your PR is submitted, it will be reviewed by one or more maintainers.
- Feedback may be provided, and updates to your branch might be required before your contribution is merged.
- Your code must pass all CI tests before it can be merged.

---

## Thank You!

We appreciate your contributions to the Decentralized Marketplace on Stacks! Together, we can build a scalable, decentralized future.
