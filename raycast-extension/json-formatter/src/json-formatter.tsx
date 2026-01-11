import {
  Action,
  ActionPanel,
  Clipboard,
  Detail,
  Form,
  showHUD,
  showToast,
  Toast,
  getPreferenceValues,
  useNavigation,
} from "@raycast/api";
import { useState } from "react";

interface Preferences {
  indentSize: string;
}

function FormattedJsonView({ formattedJson }: { formattedJson: string }) {
  const { pop } = useNavigation();

  async function copyToClipboard() {
    await Clipboard.copy(formattedJson);
    await showHUD("✅ Formatted JSON copied to clipboard!");
  }

  const markdown = `## ✅ Formatted JSON

\`\`\`json
${formattedJson}
\`\`\``;

  return (
    <Detail
      markdown={markdown}
      actions={
        <ActionPanel>
          <Action title="Copy Formatted JSON" shortcut={{ modifiers: [], key: "return" }} onAction={copyToClipboard} />
          <Action title="Back to Input" shortcut={{ modifiers: ["cmd"], key: "backspace" }} onAction={pop} />
        </ActionPanel>
      }
    />
  );
}

export default function Command() {
  const [inputJson, setInputJson] = useState<string>("");
  const [error, setError] = useState<string>("");
  const { push } = useNavigation();
  const preferences = getPreferenceValues<Preferences>();
  const indentSize = parseInt(preferences.indentSize || "2", 10);

  // Try to parse JS object literal by converting to valid JSON
  function parseJsOrJson(input: string): unknown {
    // First try standard JSON
    try {
      return JSON.parse(input);
    } catch {
      // Try to convert JS object literal to JSON
      // This handles unquoted keys like { a: 1 } -> { "a": 1 }
      try {
        // Use Function constructor to evaluate JS object literal
        const fn = new Function(`return (${input})`);
        return fn();
      } catch {
        throw new Error("Invalid JSON or JavaScript object");
      }
    }
  }

  function formatAndShow() {
    if (!inputJson.trim()) {
      showToast({
        style: Toast.Style.Failure,
        title: "No JSON",
        message: "Please paste JSON first",
      });
      return;
    }

    try {
      const parsed = parseJsOrJson(inputJson);
      const formatted = JSON.stringify(parsed, null, indentSize);
      setError("");
      push(<FormattedJsonView formattedJson={formatted} />);
    } catch (e) {
      const errorMessage = e instanceof Error ? e.message : "Invalid JSON or JavaScript object";
      setError(errorMessage);
      showToast({
        style: Toast.Style.Failure,
        title: "Invalid Input",
        message: errorMessage,
      });
    }
  }

  return (
    <Form
      actions={
        <ActionPanel>
          <Action
            title="Format JSON"
            shortcut={{ modifiers: ["cmd", "shift"], key: "return" }}
            onAction={formatAndShow}
          />
          <Action
            title="Clear"
            shortcut={{ modifiers: ["cmd", "shift"], key: "x" }}
            onAction={() => {
              setInputJson("");
              setError("");
            }}
          />
        </ActionPanel>
      }
    >
      <Form.TextArea
        id="inputJson"
        title="Input JSON"
        placeholder="Paste your JSON here..."
        value={inputJson}
        onChange={setInputJson}
      />

      {error && <Form.Description title="❌ Error" text={error} />}

      <Form.Description title="Shortcut" text="⌘⇧⏎ Cmd+Shift+Enter: Format JSON" />
    </Form>
  );
}
