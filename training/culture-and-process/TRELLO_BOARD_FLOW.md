Trello Board - Flow of Stories
==============================

A guide which aims to provide information regarding the flow of work within each teams' Trello board.

### What is Trello?

Trello is primarily a visual collaboration tool that enables you, and your team, to organise and prioritise projects in a flexible way. Trello utilises "boards", which represent a project or a place to keep track of information. At ONS Digital Publishing, each team has it's own specific board, which you will use to organise your tasks and collaborate with colleagues.

Trello boards are generally comprised of lists (shown as columns on the board) and cards. Your team board should have a minimum of six lists - 

- Sprint Backlog
- In Progress
- PR
- PO Sign-off
- Testing (Optional)
- Ready for Release
- Done

These lists keep cards (explained below) organised in their various stages of progress. They are generally used to create a workflow where cards are moved across lists from left to right, start to finish, through the board until task completion.

The fundamental unit of a board is a card (sometimes referred to as a ticket). Cards are used to represent tasks and usually outline something that needs to get done, for example a bug fix, or a feature that needs to be added to an existing service.


A "pull from the right" policy should be adhered to where possible, essentially meaning that you should be prioritising your tickets that are furthest to the right.

The process of moving cards across the board is as follows - 

### Sprint Backlog

The Sprint Backlog is where unassigned (or unclaimed) cards are kept. Any task that has not yet been started should be represented by a card in this column. If you are looking for work to do, this is a good place to start. 

After selecting a card to work on, it can then be moved to the "In Progress" column.

### In Progress

Whilst you are working on a card, it will remain in this column. Once you are at the stage that a Pull Request has been created, you can then move the card over to the "PR" column.

Please see [here](PULL_REQUEST_GUIDANCE.md) for guidance on Pull Requests. 

### PR

At this stage, code is peer-reviewed and should have passed in CI (more info on the CI/CD process can be found [here](CICD.md)). Additional work may be requested by the person reviewing your code, in which case you should ensure that this has been completed. 

Once the PR has been approved, the feature branch can be merged into `develop`, and the relevant features tested in the `develop` environment. Provided this has been completed, you can then move your card to the "PO Sign-Off" column

### PO Sign-Off

At this stage, the card should be ready to be reviewed by a tech-lead. The tech-lead will either confirm that the work is ready to be released, or they may request additional work to be done. 

This is usually communicated via comments within the card itself, which you will be notified of on the Trello board.

Once a tech-lead has confirmed that the work is ready to be released, the card can be moved to the "Ready for Release" column.

### Ready for Release

Provided that all of the above criteria have been met, you can now begin the release process. It is important that you familiarise yourself with both [version control](https://github.com/ONSdigital/dp/blob/main/guides/VERSIONING.md) and [release tagging](https://github.com/ONSdigital/dp/blob/main/guides/TAGS.md) before beginning this stage. The release process is as follows - 

1. Checkout the `master` branch of the repository you are making a new release for
2. Create a new branch from `master` named `release/x.y.z` where `x` is major, `y` is minor and `z`. If you are not sure which version is next, you can go to `https://github.com/ONSdigital/{repo-name}/releases` to see the version of the latest release
3. Merge `develop` into your release branch, commit and push the branch
4. Open up a new PR for your release
5. Post release PR and wait for a review
6. Once approved, merge the release into `master` and push the changes
7. Create a new release version on github (see version control and release tagging above)
8. Refer to [this](CICD.md) document for the next steps to deploy your app into an environment  

### Next steps

- Understanding of [70%, 20% and 10% time](./70_20_10_TIME.md)