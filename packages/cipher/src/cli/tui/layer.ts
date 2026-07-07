import { run as runTui, type TuiInput } from "@cipher-ai/tui"
import { Global } from "@cipher-ai/core/global"
import { AppNodeBuilder } from "@cipher-ai/core/effect/app-node-builder"
import { Effect } from "effect"

export function run(input: TuiInput) {
  return runTui(input).pipe(Effect.provide(AppNodeBuilder.build(Global.node)))
}
