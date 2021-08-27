### Sourcetree WORKFLOW


![alt tag](https://img.shields.io/badge/git%20-Rebase%20project-blue)
### How to Rebase it via Sourcetree?
This was a process of customising Sourcetree for more console output.

✖️ make sure you are Rebasing on your Feature branch

![alt text](https://firebasestorage.googleapis.com/v0/b/bellabeat-e59b7.appspot.com/o/rebase.png?alt=media&token=2ea465ae-a95a-4cbe-b201-3abf2ac45b31)

1. Checkout to branch you want to Rebase
2. Move to the feature branch you want to take, and go to the LAST commit (like the image)
3. Right-click and choose REBASE, not Rebase children...
![alt text](https://firebasestorage.googleapis.com/v0/b/bellabeat-e59b7.appspot.com/o/Screen%20Shot%202020-12-10%20at%204.26.00%20PM.png?alt=media&token=e564220e-0741-438a-b531-c3b773fb22db)
4. If there are conflict you will be blocked (if you do not see the Sourcetree messages log, enable them in Preference -> Advanced).
   Solve Conflicts by external tools, editors or Xcode
5. Back in Sourcetree history check commits, and click again on the same feature branch as on the start of rebase (step 3)
6. Right click there choose again REBASE, will ask to Continue Rebase
7. You should see changes from your to MASTER, Force Push in source tree to remote (picture bellow to allow this)
7. Go to github project and create the Pull request for the rebase.Set up members to approve/rejec
8. Once there are comments change the projects files and repeat REBASE to solve conflicts if there are any
9. Once that is all approved merge your Feature branch to Master and delete it

You will need to enable FORCE PUSH in Preference-Advanced-Allow Force Push

![alt text](https://firebasestorage.googleapis.com/v0/b/bellabeat-e59b7.appspot.com/o/Screen%20Shot%202020-12-11%20at%202.42.21%20PM.png?alt=media&token=ebbfbe77-e391-4578-8c58-4ef515b81849)

Resources:
https://www.coursera.org/lecture/version-control-with-git/sourcetree-rebasing-Miziw
https://www.coursera.org/lecture/version-control-with-git/sourcetree-rewriting-history-kINuI

...To be continued
