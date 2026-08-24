# Code review and change descriptions

Condensed from Google engineering practices, `https://google.github.io/eng-practices/` — the
reviewer guide and the change-author guide. Google calls a change a CL (changelist); read that
as a pull request.

## The reviewer's standard

Approve a change once it definitely improves the overall code health of the system, even when
it isn't perfect. There's no such thing as a perfect change — only better code. Continuous
improvement beats a stalled review.

Two corollaries:

- Don't block a change that improves health over a preference that doesn't.
- Don't approve a change that degrades health because the author is in a hurry, unless there's
  an emergency and a follow-up is already filed.

Where a change would improve one dimension and worsen another, say which and let the author
weigh it.

## Principles

- Technical facts and data beat opinions and personal preferences.
- On matters of style, the style guide is the absolute authority. Anything not in the style
  guide is a preference; the author's existing choice stands.
- Software design is never purely a style question. Weigh the trade-offs and reach a technical
  conclusion. Where no rule applies and both options are defensible, the author's approach wins.
- If you and the author can't agree, don't let the change sit. Escalate to the team, the tech
  lead, or the maintainer.

## What to look for

Work down this list. Each item is a question you answer for the change in front of you.

- **Design.** Does the change belong in this codebase at all? Do the interactions between
  pieces make sense? Is this the right place for it?
- **Functionality.** Does it do what the author intended? Is that what users need? Think about
  edge cases, concurrency, and failure paths, not just the happy path.
- **Complexity.** Could this be simpler? Would another engineer understand it on first read? Is
  it over-engineered for a need that hasn't arrived?
- **Tests.** Are there unit, integration, or end-to-end tests, and are they correct? Will they
  fail when the code breaks? Are they simple enough to maintain?
- **Naming.** Does each name clearly say what the thing is or does, without being unreadably
  long?
- **Comments.** Are they clear, useful, and about *why* rather than *what*? Is a comment
  explaining complexity that should have been removed instead?
- **Style.** Does it match the language's style guide? Mark a purely stylistic point that isn't
  in the guide as a nit.
- **Consistency.** Does it match the surrounding code? Where the existing code contradicts the
  style guide, the style guide wins for new code, but don't demand an unrelated cleanup.
- **Documentation.** Did the change update the README, the runbook, or the reference docs it
  invalidates?
- **Every line.** Read every line you were assigned. If you genuinely can't review some of it,
  say so and name someone who can.
- **Context.** Look at the whole file, not the diff hunk. A change that looks fine in isolation
  may be making the file worse.
- **Good things.** Say so when you see them. A review that only lists problems teaches less.

## Navigating a change

1. Read the description first, then take a broad view: does this change make sense at all? If
   it doesn't, say so immediately, before reviewing detail.
2. Look at the main parts — the file or files that carry the substance.
3. Read the rest in a logical sequence, usually the order the code executes.

## Speed

- Respond within one business day at the latest. A slow review blocks a person, not a queue.
- Optimize for the team's velocity, not your own uninterrupted time. Review at a natural break
  in focused work, not by letting reviews accumulate.
- Approve with comments when the remaining points are minor and you trust the author to apply
  them. Requiring another round for a nit costs more than it buys.
- When a change is too large to review well, ask for it to be split rather than skimming it.

## Writing review comments

- Be kind. Comment on the code, never on the person. "This function is hard to follow", not
  "you wrote this badly".
- Explain your reasoning, so the author can evaluate it rather than just comply.
- Balance giving explicit direction against pointing at the problem and letting the author
  choose. Naming the problem usually teaches more.
- Encourage simplification, or a comment, rather than accepting an explanation delivered only to
  you in the review thread. The next reader won't have that thread.
- Label a non-blocking comment: `Nit:` for a trivial polish point, `Optional:` for a suggestion,
  `FYI:` for something the author needn't act on now.
- When the author pushes back, first consider that they may be right — they've been closer to
  the code. If you still disagree, explain again with facts. Don't concede to avoid friction,
  and don't dig in over a preference.
- "I'll clean it up later" is only acceptable with a filed bug and a reference to it in the
  code.

## Writing the change description

**First line**

- A short summary of what changes, in the imperative mood: "Delete the FizzBuzz RPC and replace
  it with the batched API."
- A complete sentence, not a fragment and not a phrase like "Fix bug".
- Descriptive of what the change *does*, not what the author was doing.

**Body**, after a blank line

- What problem the change solves, and why this approach.
- Enough background that a reader who wasn't there can follow it.
- The approach's known shortcomings, if any.
- Links to the bug, the design doc, or the incident.

Treat the description as a permanent public record. Someone will read it years from now while
bisecting. "Fix build" tells them nothing.

Re-read the description before you submit: what the change does often shifts during review, and
the description has to move with it.

## Emergencies

An emergency change is a **small** one that lets a major launch proceed instead of rolling back,
fixes a bug significantly affecting users in production, handles a pressing legal issue, or
closes a major security hole. In an emergency the review process speeds up, and the quality bar
relaxes — but only for that change, and only while the emergency lasts.

Two constraints: the change must stay small, and the cleanup or follow-up belongs in a filed bug
before the emergency closes. "Emergency" is not a label you attach to a large change to skip
review.

## Receiving a review

- The review is about the code, not about you. Read it that way even when the wording is blunt.
- Fix the code rather than winning the argument. If the reviewer misread something, that's
  usually a sign the code needs a clearer name or a comment.
- Answer every comment, even if only to say you've made the change.
- Where you disagree, give the technical reason and stay open to being wrong.

## Keeping changes small

- One self-contained change per pull request. One thing, done completely, with its tests.
- There are no hard rules on size. The guide calls 100 lines usually reasonable and 1,000 lines
  usually too large, but it's the reviewer's judgment.
- File count counts toward size too: 200 lines in one file may be fine, while the same 200 lines
  spread across 50 files usually isn't.
- A reviewer may reject a change outright for being too large.
- A small change gets reviewed faster and more thoroughly, hides fewer bugs, wastes less work
  if it's rejected, merges more cleanly, and rolls back more safely.
- Deleting whole files, and a large machine-generated change, are the usual exceptions.
- Split by file, or into a series where each step stands alone and doesn't break the build.
- Keep the tests in the same change as the code they cover, even though that makes it bigger.
