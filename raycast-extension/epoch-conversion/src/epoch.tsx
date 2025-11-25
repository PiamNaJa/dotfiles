import { Action, ActionPanel, List, Icon } from "@raycast/api";
import { useState, useEffect } from "react";

const formatDate = (date: Date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

export default function Command() {
  const [searchText, setSearchText] = useState("");
  const [now, setNow] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setNow(new Date());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const getConversionItems = (text: string) => {
    if (!text) return [];

    const items = [];
    const trimmed = text.trim();

    // Try as timestamp (number)
    if (/^\d+$/.test(trimmed)) {
      const num = parseInt(trimmed, 10);
      
      let date: Date;
      let type = "";

      // Heuristic: if > 10 billion, assume milliseconds, else seconds
      // 10,000,000,000 seconds is year 2286
      if (num > 10000000000) {
        date = new Date(num);
        type = "Milliseconds";
      } else {
        date = new Date(num * 1000);
        type = "Seconds";
      }

      items.push({
        title: formatDate(date),
        subtitle: `Local (From ${type})`,
        value: formatDate(date),
        copyValue: formatDate(date),
      });
      items.push({
        title: date.toUTCString(),
        subtitle: `UTC (From ${type})`,
        value: date.toUTCString(),
        copyValue: date.toUTCString(),
      });
    } else {
      // Try as date string
      const date = new Date(trimmed);
      if (!isNaN(date.getTime())) {
        items.push({
          title: Math.floor(date.getTime() / 1000).toString(),
          subtitle: "Timestamp (Seconds)",
          value: Math.floor(date.getTime() / 1000).toString(),
          copyValue: Math.floor(date.getTime() / 1000).toString(),
        });
        items.push({
          title: date.getTime().toString(),
          subtitle: "Timestamp (Milliseconds)",
          value: date.getTime().toString(),
          copyValue: date.getTime().toString(),
        });
        items.push({
          title: date.toUTCString(),
          subtitle: "UTC",
          value: date.toUTCString(),
          copyValue: date.toUTCString(),
        });
        items.push({
          title: formatDate(date),
          subtitle: "Local",
          value: formatDate(date),
          copyValue: formatDate(date),
        });
        items.push({
          title: date.toISOString(),
          subtitle: "ISO 8601",
          value: date.toISOString(),
          copyValue: date.toISOString(),
        });
      }
    }

    return items;
  };

  const conversionItems = getConversionItems(searchText);

  return (
    <List
      onSearchTextChange={setSearchText}
      searchBarPlaceholder="Type a timestamp or date..."
      throttle
    >
      <List.Section title="Current Time">
        <List.Item
          icon={Icon.Clock}
          title={Math.floor(now.getTime() / 1000).toString()}
          subtitle="Current Timestamp (Seconds)"
          actions={
            <ActionPanel>
              <Action.CopyToClipboard content={Math.floor(now.getTime() / 1000).toString()} />
            </ActionPanel>
          }
        />
        <List.Item
          icon={Icon.Clock}
          title={now.getTime().toString()}
          subtitle="Current Timestamp (Milliseconds)"
          actions={
            <ActionPanel>
              <Action.CopyToClipboard content={now.getTime().toString()} />
            </ActionPanel>
          }
        />
        <List.Item
          icon={Icon.Calendar}
          title={formatDate(now)}
          subtitle="Current Local Time"
          actions={
            <ActionPanel>
              <Action.CopyToClipboard content={formatDate(now)} />
            </ActionPanel>
          }
        />
        <List.Item
          icon={Icon.Globe}
          title={now.toUTCString()}
          subtitle="Current UTC Time"
          actions={
            <ActionPanel>
              <Action.CopyToClipboard content={now.toUTCString()} />
            </ActionPanel>
          }
        />
        <List.Item
          icon={Icon.Globe}
          title={now.toISOString()}
          subtitle="Current ISO 8601 Time"
          actions={
            <ActionPanel>
              <Action.CopyToClipboard content={now.toISOString()} />
            </ActionPanel>
          }
        />
       
      </List.Section>

      {conversionItems.length > 0 && (
        <List.Section title="Conversion Results">
          {conversionItems.map((item, index) => (
            <List.Item
              key={index}
              icon={Icon.ArrowRight}
              title={item.title}
              subtitle={item.subtitle}
              actions={
                <ActionPanel>
                  <Action.CopyToClipboard content={item.copyValue} />
                  <Action.Paste content={item.copyValue} />
                </ActionPanel>
              }
            />
          ))}
        </List.Section>
      )}
    </List>
  );
}
