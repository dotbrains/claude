---
name: pr-review
description: Review a pull request thoroughly, analyzing the diff, comments, and providing actionable feedback.
context: fork
allowed-tools: Bash(gh *), Read, Grep, Glob
disable-model-invocation: true
argument-hint: "[PR number or URL]"
---

## Pull request context
- PR diff: !`gh pr diff $ARGUMENTS`
- PR comments: !`gh pr view $ARGUMENTS --comments`
- Changed files: !`gh pr diff $ARGUMENTS --name-only`

## Your task

Review this pull request thoroughly:

1. **Summary**: Briefly describe what the PR does
2. **Code Quality**: Check for readability, maintainability, and adherence to project conventions
3. **Potential Issues**: Identify bugs, edge cases, or security concerns
4. **Suggestions**: Provide specific, actionable feedback with code examples
5. **Verdict**: Approve, request changes, or comment

Organize feedback by priority:
- **Critical** (must fix before merge)
- **Warning** (should fix)
- **Suggestion** (nice to have)
