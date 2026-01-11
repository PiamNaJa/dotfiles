# JSON Formatter (Raycast Extension)

## Overview

This project is a Raycast extension designed to format JSON strings and JavaScript object literals. It prioritizes a clean, error-resistant user experience by separating the input and output phases.

## Workflow

1.  **Input View**:
    - A simple `Form` interface.
    - User pastes a JSON string or a JS object literal (e.g., `{ a: 1 }`).
    - **Action**: `Cmd+Shift+Enter` parses the input and navigates to the output view.
2.  **Output View**:
    - A `Detail` view showing the formatted JSON in a markdown code block.
    - **Read-Only**: Ensures the output remains consistent.
    - **Actions**:
      - `Enter`: Copy formatted JSON to clipboard.
      - `Cmd+Backspace`: Navigate back to the input view.

## Technical Implementation

- **File Structure**:
  - `src/json-formatter.tsx`: Main command file containing both the Input Form and Output Detail components.
- **Parsing Logic**:
  - First attempts `JSON.parse` for standard JSON.
  - Fallbacks to `new Function` to evaluate JavaScript object literals (handling unquoted keys).
- **State Management**:
  - Uses `useState` for input content and error states.
  - Uses `useNavigation` to switch between views.

## Development Commands

- `pnpm run dev`: Start the development server and open Raycast.
- `pnpm run build`: Build the extension for production.
- `pnpm run lint`: Run linting checks.
