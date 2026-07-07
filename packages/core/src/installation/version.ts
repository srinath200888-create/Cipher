declare global {
  const CIPHER_VERSION: string
  const CIPHER_CHANNEL: string
}

export const InstallationVersion = typeof CIPHER_VERSION === "string" ? CIPHER_VERSION : "local"
export const InstallationChannel = typeof CIPHER_CHANNEL === "string" ? CIPHER_CHANNEL : "local"
export const InstallationLocal = InstallationChannel === "local"
