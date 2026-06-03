export const meta = {
  name: 'auto-implement',
  description: 'Implement all GitHub issues labeled auto-impl in parallel, one agent per issue',
  whenToUse: 'When user says "начни работу", "запусти авто-реализацию", "auto-implement", or similar.',
  phases: [
    { title: 'Fetch issues' },
    { title: 'Implement' },
  ],
}

const REPO = 'antonkupreychik/plants-care-mobile'
const LABEL = 'auto-impl'

// ── Phase 1: fetch open issues labeled auto-impl ────────────────────────────

phase('Fetch issues')
log(`Fetching open issues labeled "${LABEL}" from ${REPO}…`)

const fetcher = await agent(
  `Run this exact command and return the result as JSON:
gh issue list --repo ${REPO} --label "${LABEL}" --state open --json number,title,body --limit 20

Return ONLY a JSON object like: { "issues": [ { "number": 42, "title": "...", "body": "..." } ] }
If there are no issues, return { "issues": [] }.`,
  {
    schema: {
      type: 'object',
      required: ['issues'],
      properties: {
        issues: {
          type: 'array',
          items: {
            type: 'object',
            required: ['number', 'title'],
            properties: {
              number: { type: 'integer' },
              title:  { type: 'string' },
              body:   { type: 'string' },
            },
          },
        },
      },
    },
  }
)

const issues = fetcher.issues.filter(Boolean)

if (!issues.length) {
  log(`No open issues with label "${LABEL}" found. Nothing to do.`)
  return { implemented: [] }
}

log(`Found ${issues.length} issue(s): ${issues.map(i => `#${i.number} "${i.title}"`).join(' | ')}`)

// ── Phase 2: implement each issue in parallel, isolated worktrees ────────────

phase('Implement')

const results = await parallel(issues.map(issue => async () => {
  const branchSlug = issue.title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .slice(0, 45)
  const branch = `feature/auto-${issue.number}-${branchSlug}`

  return await agent(
    `You are implementing GitHub issue #${issue.number} for the Flutter mobile app in repo ${REPO}.

## Issue
Title: ${issue.title}
Body:
${issue.body || '(no description provided)'}

## What to do — follow this order exactly

1. Read FLUTTER.md — it has all conventions (stack, structure, naming, codegen rules).
2. Read the relevant existing feature code in lib/features/ to understand patterns.
3. Implement the feature following ship-mobile-feature conventions:
   - data layer: DTO mappers, RepositoryImpl
   - domain layer: models (freezed), repository interface
   - presentation layer: Riverpod Notifier + screen/widgets (Material 3, AppLocalizations)
   - tests: unit tests for repository + notifier, widget test for the screen
4. Run: flutter analyze --fatal-infos
5. Run: flutter test (fix any failures before continuing)
6. Create a PR to main with:
   - title: "feat: ${issue.title}"
   - body: "Closes #${issue.number}\\n\\nAuto-implemented by Claude."
   - branch: ${branch}
   - base: main
7. Enable auto-merge on the PR: gh pr merge <PR-URL> --auto --squash

## Key conventions (from FLUTTER.md)
- Feature-first structure: lib/features/<feature>/{data,domain,presentation}/
- No cross-feature presentation imports — share only through core/ or domain interfaces
- All UI strings via AppLocalizations (ru ARB only)
- AuthScope: use AuthScope.user for endpoints that need user auth, AuthScope.none for public
- Result<T> pattern (freezed sealed) for all repository return types
- Riverpod codegen (@riverpod annotation), run build_runner if you add new providers
- Generated files (*.g.dart, *.freezed.dart) must be committed

## Important
- Work on branch ${branch} (already checked out in your worktree)
- Do NOT touch other features' files unless strictly necessary
- If the issue is unclear or blocked by a backend gap, document it in docs/BACKEND-GAPS.md and create a minimal stub PR so the issue is tracked
- Repo: ${REPO}

Return a short summary: what was implemented, PR URL, and any gaps found.`,
    {
      label: `issue-#${issue.number}`,
      phase: 'Implement',
      isolation: 'worktree',
    }
  )
}))

const summary = issues.map((issue, i) => ({
  number: issue.number,
  title: issue.title,
  result: results[i] ?? 'agent did not return a result',
}))

log('All agents finished.')
for (const item of summary) {
  log(`#${item.number} "${item.title}": ${String(item.result).slice(0, 200)}`)
}

return { implemented: summary }
