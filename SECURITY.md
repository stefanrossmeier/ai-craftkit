Security Policy

Thank you for helping keep ai-craftkit safe.

This repository contains reusable skills, templates, and examples for AI-assisted software engineering workflows. The project does not contain a running service, but its skills may guide agents while they inspect repositories and generate documentation. Security issues in this project usually involve unsafe instructions, accidental secret exposure, or generated output that could mislead users.

Reporting a Security Issue

Please report security issues privately.

Do not open a public GitHub issue for vulnerabilities or suspected security problems.

Use GitHub private vulnerability reporting if it is enabled for this repository. Otherwise, contact the maintainer directly through GitHub.

Please include:

affected skill, template, or example
a short description of the issue
why it may be unsafe
steps to reproduce, if applicable
suggested fix, if you have one
What Counts as a Security Issue

Examples of security-relevant issues include:

a skill instructs an agent to print secret values
a skill encourages reading sensitive files in full
generated documentation may include credentials, tokens, keys, or private data
a template encourages copying .env values into docs
a skill suggests running destructive commands by default
a skill suggests deployment, Docker, install, or server commands without appropriate caution
a prompt could cause an agent to overwrite important files unexpectedly
a workflow hides uncertainty in security-sensitive areas
an example includes real credentials or private data
instructions make authentication, authorization, permissions, or trust boundaries misleading

Security-sensitive files include, but are not limited to:

.env
.env.*
*.pem
*.key
*.crt
id_rsa
id_ed25519
secrets.*
credentials.*

It is acceptable for generated documentation to mention that such files exist when relevant. It should not copy their values.

Safe Repository Inspection

Skills in this repository should prefer safe read-only inspection.

They should not encourage agents to run commands that may:

install dependencies
start servers
run Docker
deploy software
modify production data
delete files
print secrets
exfiltrate repository contents
make network calls without a clear reason

When a command may be expensive, destructive, networked, or state-changing, the skill should avoid it unless the user explicitly asks for it and the risk is clear.

Handling Secrets

Contributions must not include secrets, credentials, private keys, access tokens, customer data, or private repository content.

If you accidentally commit sensitive data:

Remove it immediately.
Rotate the affected secret.
Notify the maintainer privately.
Do not rely on deleting the GitHub file alone, because the secret may remain in history.
Generated Documentation Safety

Generated documentation should be useful without leaking private data.

Skills should:

document secret names only when relevant
avoid secret values
mark uncertain security assumptions clearly
identify missing authentication or authorization evidence
avoid presenting inferred security behavior as verified
include open questions when security controls cannot be confirmed

For example:

Good:
- `.env.example` documents required variables.
- `.env` exists locally, but values were not read.
- Authorization behavior could not be verified from the inspected files.

Bad:
- `API_KEY=...`
- `DATABASE_PASSWORD=...`
- “The endpoint is secure” without evidence.
Security Review Areas

When contributing skills or templates, pay special attention to:

authentication
authorization
secret handling
environment variables
deployment instructions
destructive commands
file deletion
database migrations
external API calls
webhooks
queues and retries
generated documentation that may expose private data
agent instructions that may overclaim or hide uncertainty
Supported Versions

This project is distributed as repository content, not as a packaged runtime.

Security fixes apply to the current main branch unless release branches or versioned packages are introduced later.

Responsible Disclosure

Please give the maintainer reasonable time to review and fix reported issues before discussing them publicly.

The goal is to improve the safety of the skills and documentation without exposing users to avoidable risk.

Non-Security Issues

For normal bugs, documentation improvements, unclear wording, or feature suggestions, please use regular GitHub issues or pull requests.