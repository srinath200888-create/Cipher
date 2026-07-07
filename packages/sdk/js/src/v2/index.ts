export * from "./client.js"
export * from "./server.js"

import { createCipherClient } from "./client.js"
import { createOpencodeServer } from "./server.js"
import type { ServerOptions } from "./server.js"

export * as data from "./data.js"

export async function createOpencode(options?: ServerOptions) {
  const server = await createOpencodeServer({
    ...options,
  })

  const client = createCipherClient({
    baseUrl: server.url,
  })

  return {
    client,
    server,
  }
}
