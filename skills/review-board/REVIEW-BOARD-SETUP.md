# Review Board — multi-agent code review for VS Code (Local harness)

## What this installs

- `.github/agents/review-board.agent.md` — visible coordinator that gathers a diff, runs three independent discovery reviews and calls the verifier twice.
- `.github/agents/review-correctness.agent.md` — hidden worker for logic bugs and edge cases.
- `.github/agents/review-reliability.agent.md` — hidden worker for regressions, failure handling and concurrency.
- `.github/agents/review-security.agent.md` — hidden worker for security flaws.
- `.github/agents/review-verifier.agent.md` — hidden worker; invoked **twice, with separate fresh contexts**, to vote on claims.

The system labels findings Important / Nit / Pre-existing, rates them P0–P3 and High / Medium / Low confidence, and only counts a newly introduced bug as confirmed if both verifiers independently CONFIRM it.

## Install on macOS or Linux

From the **root of your Git repository**, extract the release ZIP (adjust Downloads path if different):

```bash
unzip -n ~/Downloads/vscode-review-board.zip -d .
```

The `-n` flag avoids overwriting existing files; inspect any existing `.github/agents/*` before updating. You can also copy the five `.agent.md` files into `.github/agents/` manually. No VS Code extension development or npm install is required, but you do need VS Code with GitHub Copilot/chat model access and subagent support.

## Run

1. Open your repository root in **VS Code**.
2. Open Chat, choose the **Local** harness (not Copilot / Claude / Codex), then choose **Review Board** in the custom-agent dropdown. (For monorepos where you open a subfolder, VS Code can discover parent-repo customizations with `chat.useCustomizationsInParentRepositories` enabled.)
3. From **Configure Tools**, ensure `Run Subagent` (`agent/runSubagent`) is available. The coordinator also uses `execute` for read-only Git inspection; VS Code might ask to approve this tool.
4. Send: `Review all my tracked staged and unstaged changes against HEAD. Run all 3 independent reviewers, then 2 fresh verifier invocations. Only report 2/2 confirmed introduced bugs as confirmed. Show votes, severity and confidence.`
5. Expand the subagent calls in chat to check that all three discovery workers and two independent verifier invocations actually ran. A printed 2/2 without real separate invocations is not valid.

Alternative: for a PR or a selected file, attach a Pull Request or Source Control changes using **Add Context** in chat and specify that scope. If shell execution is disabled, attach the diff explicitly; the coordinator must tell you when it cannot establish the actual changeset.

## Review protocol and rating scale

- **Important**: verified newly introduced behavioral or security defect.
- **Nit**: optional polish or a test gap without an independently proven defect; nonblocking.
- **Pre-existing**: existed before the reviewed change, with baseline evidence; nonblocking for current diff.
- **Priority**: P0 emergency, P1 high impact, P2 meaningful bug, P3 minor impact.
- **Confidence**: qualitative High / Medium / Low based on evidence. It is not an estimated probability.
- **Votes**: 2/2 means two distinct verifier invocations confirmed the new defect. 1/2 or UNCERTAIN is disputed, never confirmed.

Expected report excerpt (illustrative, NOT an actual finding):

| ID | Class | Priority | Confidence | Votes | Location | Issue |
|---|---|---|---|---|---|---|
| R1 | Important | P1 | High | 2/2 | `src/api/session.ts:74` | Expired token is accepted when the refresh request fails |

A real finding should include a reproducer/trigger, the actual path through code, why the change introduced the problem, and a suggested fix or test. The final verdict is advisory; it does **not** automatically block merging or comment on PRs. A 2/2 vote does not mathematically guarantee correctness; both model runs can share blind spots.

## Safety and limitations

- The three discovery workers and the verifier have only `read` and `search` tools; the coordinator has `execute` to read Git metadata/diffs. The coordinator instructions restrict it to read-only Git commands, but **tool permissions do not mechanically prevent all mutating commands**. Inspect command approval requests. For an entirely tool-enforced no-shell setup, remove `execute` from the coordinator's frontmatter and provide an attached diff/Source Control context instead.
- This does not run tests, make code changes, create PR comments, or install a CI merge gate.
- Default scope is `git diff HEAD`: tracked, staged + unstaged edits. It omits untracked files. Supply untracked files manually. Specify a base if you want the whole feature branch reviewed.
- Large diffs may exceed model context; the coordinator must report skipped files. Subagents may run concurrently when supported by the chosen harness; parallelism is not guaranteed.
- All models may miss bugs or agree on a false claim. Human review, tests and CI remain important.
- Model calls from five or more subagent tasks can use noticeably more model credits/tokens than a single-pass review.

## Troubleshooting

- **Review Board not visible:** open repo root, use Local harness, reload VS Code and check `Chat: Open Customizations` → Agents. The helper workers are intentionally hidden.
- **No subagents run:** enable Run Subagent in Configure Tools and ask explicitly for independent subagents. Check case-sensitive worker names.
- **No diff accessible:** attach the relevant Source Control changes or a patch to chat; do not assume the tool can see untracked files.
- **Using Copilot harness instead of Local:** custom agent names/`tools` may be interpreted differently, and Local's `agents:` coordination field and `runSubagent` details are not portable. Switch to Local for this kit or adapt it to native Copilot subagents.

Official references (verified November 2026):
- https://code.visualstudio.com/docs/agent-customization/custom-agents
- https://code.visualstudio.com/docs/agents/run/subagents
- https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference
- https://code.visualstudio.com/docs/chat/copilot-chat-context
