# Aaron Junkers WinGet Configure list

> [!WARNING]
> This is currently work in progress

Based on [Clint Rutkas setup scripts](https://github.com/crutkas/setup)

This is my winget configure script to set up a new computer.  Still work in progress.  There will need to be a hybrid of Needing admin to run.

Most everything in the dsc.yml should work.

## Assumptions:

- New computer with Windows 11 that can boot a dev drive.
- C:\ can be shrunk by 75 gigs to create dev drive. 
- D:\ will be dev drive

## To Run:

1. Open Windows PowerShell
2. set execution policy
3. Copy boot.ps1 to your user folder
4. run `.boot.ps1`
5. reset execution policy
