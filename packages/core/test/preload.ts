import path from "path"

process.env.CIPHER_DB = ":memory:"
process.env.CIPHER_MODELS_PATH = path.join(import.meta.dir, "plugin", "fixtures", "models-dev.json")
process.env.CIPHER_DISABLE_MODELS_FETCH = "true"
