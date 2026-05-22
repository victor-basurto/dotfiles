# Obsidian Hubs

The list below shows my current hubs for Obsidian.
You can create your own. Each file should be created as an empty file.
Obsidian will use these files as `tags`

## Hub list

- `angular.md`
- `bash.md`
- `brookfield.md`
- `database.md`
- `devops.md`
- `discussion.md`
- `docker.md`
- `dotnet.md`
- `enhancements.md`
- `eslint.md`
- `estimates.md`
- `forms.md`
- `git.md`
- `github.md`
- `headless.md`
- `javascript.md`
- `jira.md`
- `kubernetes.md`
- `landsites.md`
- `lazyvim.md`
- `learning.md`
- `linux.md`
- `markdown.md`
- `mll.md`
- `mvc.md`
- `nextjs.md`
- `nvim.md`
- `obsidian.md`
- `planning.md`
- `powershell.md`
- `react-snippets.md`
- `react.md`
- `sitecore.md`
- `snippets.md`
- `sql.md`
- `tailwindcss.md`
- `theming.md`
- `todo.md`
- `typescript.md`
- `umbraco.md`
- `vim.md`
- `vue.md`
- `web-dev.md`
- `work.md`
- `xcentium.md`
- `xmcloud-learning.md`
- `xmcloud-websites.md`
- `xmcloud-work.md`
- `xmcloud.md`

## Create All Files at Once Pro-Tip

Here is an extra tip if you want to create multiple files at once

### MacOS

```bash
# e.g.
touch {angular,lint,vim,linux,db,devops,xmcloud,todo,ts}.md
# you get the idea
```

### Windows

```ps1
# e.g. using the `ni` command
ni (echo angular lint vim linux db devops xmcloud todo ts | % { "$_.md" })

# or use the `ForEach-Object`
'angular','lint','vim','linux','db','devops','xmcloud','todo','ts' | ForEach-Object {New-Item "$_.md"}
```
