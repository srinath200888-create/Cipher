import { Config } from "effect"

export function truthy(key: string) {
  const value = process.env[key]?.toLowerCase()
  return value === "true" || value === "1"
}

const copy = process.env["CIPHER_EXPERIMENTAL_DISABLE_COPY_ON_SELECT"]
const fff = process.env["CIPHER_DISABLE_FFF"]

function enabledByExperimental(key: string) {
  return process.env[key] === undefined ? truthy("CIPHER_EXPERIMENTAL") : truthy(key)
}

export const Flag = {
  OTEL_EXPORTER_OTLP_ENDPOINT: process.env["OTEL_EXPORTER_OTLP_ENDPOINT"],
  OTEL_EXPORTER_OTLP_HEADERS: process.env["OTEL_EXPORTER_OTLP_HEADERS"],

  CIPHER_AUTO_HEAP_SNAPSHOT: truthy("CIPHER_AUTO_HEAP_SNAPSHOT"),
  CIPHER_GIT_BASH_PATH: process.env["CIPHER_GIT_BASH_PATH"],
  CIPHER_CONFIG: process.env["CIPHER_CONFIG"],
  CIPHER_CONFIG_CONTENT: process.env["CIPHER_CONFIG_CONTENT"],
  CIPHER_DISABLE_AUTOUPDATE: truthy("CIPHER_DISABLE_AUTOUPDATE"),
  CIPHER_ALWAYS_NOTIFY_UPDATE: truthy("CIPHER_ALWAYS_NOTIFY_UPDATE"),
  CIPHER_DISABLE_PRUNE: truthy("CIPHER_DISABLE_PRUNE"),
  CIPHER_DISABLE_TERMINAL_TITLE: truthy("CIPHER_DISABLE_TERMINAL_TITLE"),
  CIPHER_SHOW_TTFD: truthy("CIPHER_SHOW_TTFD"),
  CIPHER_DISABLE_AUTOCOMPACT: truthy("CIPHER_DISABLE_AUTOCOMPACT"),
  CIPHER_DISABLE_MODELS_FETCH: truthy("CIPHER_DISABLE_MODELS_FETCH"),
  CIPHER_DISABLE_MOUSE: truthy("CIPHER_DISABLE_MOUSE"),
  CIPHER_FAKE_VCS: process.env["CIPHER_FAKE_VCS"],
  CIPHER_SERVER_PASSWORD: process.env["CIPHER_SERVER_PASSWORD"],
  CIPHER_SERVER_USERNAME: process.env["CIPHER_SERVER_USERNAME"],
  CIPHER_DISABLE_FFF: fff === undefined ? process.platform === "win32" : truthy("CIPHER_DISABLE_FFF"),

  // Experimental
  CIPHER_EXPERIMENTAL_FILEWATCHER: Config.boolean("CIPHER_EXPERIMENTAL_FILEWATCHER").pipe(
    Config.withDefault(false),
  ),
  CIPHER_EXPERIMENTAL_DISABLE_FILEWATCHER: Config.boolean("CIPHER_EXPERIMENTAL_DISABLE_FILEWATCHER").pipe(
    Config.withDefault(false),
  ),
  CIPHER_EXPERIMENTAL_DISABLE_COPY_ON_SELECT:
    copy === undefined ? process.platform === "win32" : truthy("CIPHER_EXPERIMENTAL_DISABLE_COPY_ON_SELECT"),
  CIPHER_MODELS_URL: process.env["CIPHER_MODELS_URL"],
  CIPHER_MODELS_PATH: process.env["CIPHER_MODELS_PATH"],
  CIPHER_DB: process.env["CIPHER_DB"],

  CIPHER_WORKSPACE_ID: process.env["CIPHER_WORKSPACE_ID"],
  CIPHER_EXPERIMENTAL_WORKSPACES: enabledByExperimental("CIPHER_EXPERIMENTAL_WORKSPACES"),

  // Evaluated at access time (not module load) because tests, the CLI, and
  // external tooling set these env vars at runtime.
  get CIPHER_DISABLE_PROJECT_CONFIG() {
    return truthy("CIPHER_DISABLE_PROJECT_CONFIG")
  },
  get CIPHER_EXPERIMENTAL_REFERENCES() {
    return enabledByExperimental("CIPHER_EXPERIMENTAL_REFERENCES")
  },
  get CIPHER_TUI_CONFIG() {
    return process.env["CIPHER_TUI_CONFIG"]
  },
  get CIPHER_CONFIG_DIR() {
    return process.env["CIPHER_CONFIG_DIR"]
  },
  get CIPHER_PURE() {
    return truthy("CIPHER_PURE")
  },
  get CIPHER_PERMISSION() {
    return process.env["CIPHER_PERMISSION"]
  },
  get CIPHER_PLUGIN_META_FILE() {
    return process.env["CIPHER_PLUGIN_META_FILE"]
  },
  get CIPHER_CLIENT() {
    return process.env["CIPHER_CLIENT"] ?? "cli"
  },
}
