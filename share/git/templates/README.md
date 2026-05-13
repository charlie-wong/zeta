# Git 初始化模板仓库

1. 创建空白模板库 `cd foo; git init --template`
2. 添加模板文件: foo/README.md 或 foo/.git/hooks/...
3. 执行 `git add .; git commit -m 'init commit'`
4. 将 foo/.git 作为模板使用(利用拷贝至新建仓库的 .git 目录特性)
5. `git init --template path/to/bar/.git && git reset --hard`

```bash
# 将 foo 目录下非<点>开头的文件复制到新建仓库的 .git 目录
git init --template=path/to/foo && git reset --hard

# 优先级: git init --template > GIT_TEMPLATE_DIR > init.templateDir > 默认模板
git init --template= # 使用 git 默认模板
```

- none      仅包含 .gitignore 文件
