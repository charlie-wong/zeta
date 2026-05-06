<div align="center"><h1>Markdown 语法</h1></div>

mdBook's [parser](https://github.com/raphlinus/pulldown-cmark) adheres to the
[CommonMark](https://commonmark.org/) specification with some extensions described below.
For a more in-depth experience, check out the [Markdown Guide](https://www.markdownguide.org).

## 标题

Headings use the `#` marker and should be on a line by themselves.

```markdown
#      H1 Heading
##     H2 Heading
###    H3 Heading
####   H4 Heading
#####  H5 Heading
###### H6 Heading
```

## 强调

```md
- *Italics* or _Italics_
- **Bold**  or __Bold__
- ~~Strikethrough~~
- **~~bold~~ and _italics_**
```

- *Italics* or _Italics_
- **Bold**  or __Bold__
- ~~Strikethrough~~
- **~~bold~~ and _italics_**

## 列表

Lists can be unordered or ordered. Ordered lists will order automatically.

```markdown
- 无序列表: 前缀 `*` 或 `-` 或 `+`
- milk
- eggs

1. 有序列表: 数字 + 点
1. carrots
1. celery
```

> - milk
> - eggs
>
> 1. carrots
> 1. celery

## 链接

Linking to a URL or local file is easy:

```markdown
- Read about [mdBook](mdbook.md).
- link to individual headings [Headings](#headings)
- Use [mdBook](https://github.com/rust-lang/mdBook).
- now [an link] that is not inline, unlike the above.
- A bare url: <https://www.rust-lang.org>.

[an link]: https://github.com/rust-lang/mdBook

- <邮箱地址>和<URL地址>自动转换为链接
- <https://www.baidu.com>
- <charlie-wong@outlook.com>
```

> - Read about [mdBook](mdbook.md).
> - link to individual headings [Headings](#headings)
> - Use [mdBook](https://github.com/rust-lang/mdBook).
> - now [an link] that is not inline, unlike the above.
> - A bare url: <https://www.rust-lang.org>.

[an link]: https://github.com/rust-lang/mdBook

- <邮箱地址>和<URL地址>自动转换为链接
- <https://www.baidu.com>
- <charlie-wong@outlook.com>

----

You can link to individual headings with `#` fragments. The ID is created by transforming
the heading such as converting to lowercase and replacing spaces with dashes.

## 图片

```markdown
![Rust Logo](images/rust-logo-blk.svg)
![图片描述](https://image.url/x.png "说明")

reference-style ![图片描述][octocat]
[octocat]: https://image.url/x.png "图片说明"
```

The embed HTML fragments in markdown

```html
<img src="images/rust-logo.svg" alt="Rust Logo"/>

<img src="image-url" alt="描述" height="150"/>
<img src="image-url" alt="描述" style="width: 50%;"/>
<img src="image-url" alt="描述" width="300" height="200"/>

<picture>
  <source media="(max-width: 768px)"  srcset="mobile-image.jpg" />
  <source media="(max-width: 1024px)" srcset="tablet-image.jpg" />
  <img src="desktop-image.jpg" alt="响应式图片" style="width: 100%; height: auto;" />
</picture>
```

## 语法高亮

- 单个 \` 符号 `inline-style` 内联代码高亮
- 三个 ` 符号或 ~ 符号(语言名)多行语法高亮
  ```javascript
  // JavaScript 示例
  function greeting(name) {
    return `你好，${name}！`;
  }
  console.log(greeting('ToMarkdown'));
  ```

## 段落折叠

<details>

<summary>Tips for collapsed section</summary>

### You can add a header

You can add text, image or a code block, too.

</details>

## 引用

用 `>` 符号开头进行段落引用

> 这是第一级引用
>
> > 这是第二级引用
> >
> > > 这是第三级引用

> #### 引用中亦可用标题、列表、代码块等
>
> - 改进的性能
> - 新的 API 接口
>
> ```js
> const newFeature = () => {
>   console.log("Hello, World!");
> };
> ```

## 水平分割线

连续 3 各 `-` 或 `_` 或 `*` 号(注意段落间空格行)

---

随后的段落文字

## HTML 标签

- 用 `<br>`  实现换行
- 用 `<img>` 添加图片
- 用 `<div>` 控制格式

- 上标 Y<sup>2</sup>
- 下表 X<sub>1</sub>

## 删除线

Text may be rendered with a horizontal line through the center by wrapping the text with one or two
tilde characters on each side:

```text
An example of ~~strikethrough text~~.
```

> An example of ~~strikethrough text~~.

This follows the [GitHub Strikethrough extension][gfm-strikethrough].

[gfm-strikethrough]: https://github.github.com/gfm/#strikethrough-extension-

## 脚注/脚标

A footnote generates a small numbered link in the text which when clicked takes the reader to the
footnote text at the bottom of the item. The footnote label is written similarly to a link reference
with a caret at the front. The footnote text is written like a link reference definition, with the
text following the label.

```text
This is an example of a footnote[^note].

[^note]: This text is the footnote, which will be rendered towards the bottom.
```

This example will render as:

> This is an example of a footnote[^note].
>
> [^note]: This text is the footnote, which will be rendered towards the bottom.

The footnotes are automatically numbered based on the order the footnotes are written.

## 表格

Tables can be written using pipes and dashes to draw the rows and columns of the table. These will
be translated to HTML table matching the shape.

```text
| 右对齐        | 居中          | 左对齐   | 默认左对齐 |
|:------------- |:-------------:| --------:| ---------- |
| col 2 is      | centered      | $12      |       what |
| zebra stripes | neat          | $1       | ask ok     |
```

| 右对齐        | 居中          | 左对齐   | 默认左对齐 |
|:------------- |:-------------:| --------:| ---------- |
| col 2 is      | centered      | $12      |       what |
| zebra stripes | neat          | $1       | ask ok     |

HTML 标签绘制复杂表格

<table>
  <thead>
    <tr>
      <th rowspan="2">功能模块</th>
      <th colspan="2">开发进度</th>
      <th rowspan="2">负责人</th>
    </tr>
    <tr>
      <th>前端</th>
      <th>后端</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>用户管理</td>
      <td>100%</td>
      <td>100%</td>
      <td>Alice</td>
    </tr>
    <tr>
      <td>数据分析</td>
      <td>80%</td>
      <td>90%</td>
      <td>Bob</td>
    </tr>
  </tbody>
</table>

See [GitHub Tables extension][gfm-tables] for more details on the exact syntax supported.

[gfm-tables]: https://github.github.com/gfm/#tables-extension-

## 任务列表

Task lists can be used as a checklist of items that have been completed.

```md
- [x] Complete task
- [ ] Incomplete task
```

> - [x] Complete task
> - [ ] Incomplete task

See [GitHub Task List extension][gfm-task-list] for more details.

[gfm-task-list]: https://github.github.com/gfm/#task-list-items-extension-

## 智能标点

Some ASCII punctuation sequences will be automatically turned into fancy Unicode characters:

| ASCII sequence | Unicode |
|----------------|---------|
| `--`           | –       |
| `---`          | —      |
| `...`          | …      |
| `"`            | “ or ” depending on context |
| `'`            | ‘ or ’ depending on context |

mdBook enable this feature by default.
To disable it, see the [`output.html.smart-punctuation`] config option.

[`output.html.smart-punctuation`]: https://rust-lang.github.io/mdBook/format/configuration/renderers.html#html-renderer-options

## 标题属性

Headings can have a custom HTML ID and classes. This lets you maintain the same ID even
if you change the heading's text, it also lets you add multiple classes in the heading.

```md
# Example Heading { #first .class1 .class2 }
```

This makes the level 1 heading with the content `Example Heading`, ID `first`, and classes `class1`
and `class2`. Note that the attributes should be space-separated. More information can be found in
the [heading attrs spec page](https://github.com/raphlinus/pulldown-cmark/blob/master/pulldown-cmark/specs/heading_attrs.txt).

## 定义列表

Definition lists can be used for things like glossary entries. The term is listed on a line by itself,
followed by one or more definitions. Each definition must begin with a `:` (after 0-2 spaces).

```md
term A
  : This is a definition of term A. Text
    can span multiple lines.

term B
  : This is a definition of term B.
  : This has more than one definition.
```

term A
  : This is a definition of term A. Text
    can span multiple lines.

term B
  : This is a definition of term B.
  : This has more than one definition.

Terms are clickable just like headers, which will set the browser's URL to point directly to that term.

See the [definition lists spec](https://github.com/pulldown-cmark/pulldown-cmark/blob/HEAD/pulldown-cmark/specs/definition_lists.txt)
for more information on the specifics of the syntax.

mdBook enable this feature by default.
To disable it, see the [`output.html.definition-lists`] config option.

[`output.html.definition-lists`]: https://rust-lang.github.io/mdBook/format/configuration/renderers.md#html-renderer-options

## 转义特殊字符

- `\`  反斜杠, \` 反引号,  `*` 星号, `_` 下划线, `{}` 大括号, `[]` 方括号
- `()` 圆括号, `#` 井号,   `+` 加号, `-` 连字符, `.`  点号,   `!` 感叹号

## GitHub 提示警告

An admonition is a special type of callout or notice block used to highlight important information.
It is written as a blockquote with a special tag on the first line.

```markdown
> [!NOTE]
> General information or additional context.

> [!TIP]
> A helpful suggestion or best practice.

> [!IMPORTANT]
> Key information that shouldn't be missed.

> [!WARNING]
> Critical information that highlights a potential risk.

> [!CAUTION]
> Information about potential issues that require caution.
```

> [!NOTE]
> General information or additional context.

> [!TIP]
> A helpful suggestion or best practice.

> [!IMPORTANT]
> Key information that shouldn't be missed.

> [!WARNING]
> Critical information that highlights a potential risk.

> [!CAUTION]
> Information about potential issues that require caution.

## GitHub 彩色文本

- 用 `\` 表示空格(基于 LaTeX 语法)
  - $\color{red}      红色 \ 文字$
  - $\color{cyan}     青色 \ 文字$
  - $\color{blue}     蓝色 \ 文字$
  - $\color{violet}   浅紫 \ 文字$
  - $\color{orange}   橘色 \ 文字$
  - $\color{yellow}   黄色 \ 文字$
  - $\color{lime}     浅绿 \ 文字$
  - $\color{green}    深绿 \ 文字$
  - $\color{magenta}  紫色 \ 文字$

- HEX 格式：
  - 主色调：`#007bff` (蓝色)
  - 辅助色：`#28a745` (绿色)
  - 警告色：`#ffc107` (黄色)
  - 危险色：`#dc3545` (红色)

- RGB 格式：
  - 背景色：`rgb(248, 249, 250)`
  - 文字色：`rgb(33, 37, 41)`

- HSL 格式：
  - 强调色：`hsl(210, 100%, 50%)`
  - 中性色：`hsl(0, 0%, 50%)`

## GitHub 交流协作

- 自动转换为链接 `@用户名` 或 `@组织名/团队名`
- 自动转换为链接 `#Issue编号` 或 `#PR编号`
- 自动转换为链接 `用户名/仓库名#编号` 跨仓库引用

## GitHub 数学公式

> 基于 LaTeX 语法，‌行内公式使用单个美元符 `$` 包裹‌，块级公式使用两个美元符号 `$$` 包裹

- <https://www.tomarkdown.org/zh/guides/markdown-math>
- 上标用 `^` 符号，下标用 `_` 符号，多字符需花括号 `{}` 分组：`x^2‌` 表示 x 平方，‌`x_{i+1}‌` 表示下标
- 分数用 ‌`\frac{分子}{分母}`，根号用 ‌`\sqrt{表达式}`，开 n 次根 ‌`\sqrt[n]{表达式}‌`

- 希腊字母小写：`\alpha`, `\beta`, `\gamma`, `\delta`, `\epsilon`, `\pi`, `\sigma`, `\theta`, `\phi`, `\psi`, `\omega`
- 希腊字母大写：`\Alpha`, `\Beta`, `\Gamma`, `\Delta`, `\Epsilon`, `\Pi`, `\Sigma`, `\Theta`, `\Phi`, `\Psi`, `\Omega`
- 属于 `\in`, 不属于 `\notin`, 包含 `\subset`, 并集 `\cup`, 交集 `\cap`, 空集 `\emptyset`, 向量 `\vec{x}`

- 运算符包括求和 ‌`\sum‌`、积分 ‌`\int‌`、乘号 ‌`\times‌`、无穷 `\infty`，约等于 `\approx`

- 行内公式：$E = mc^2, \alpha, \beta, \pi, \int_{-\infty}^{+\infty}, \sqrt{2+x}, \sqrt[y]{a+b}$
- 行内公式：$\times, \cdot, \div, \neq, \geq, \leq$

块级公式：

$$
\sum_{i=1}^n a_i=0, y = \frac{1}{1 + e^-x}, \binom{n}{k} \tag{1}
$$

$$
\lim_{x \to 0} \frac{\sin x}{x} = 1, \quad \lim_{n \to \infty} \left(1 + \frac{1}{n}\right)^n = e
$$

`pmatrix` 创建带圆括号的矩阵，`&` 符号用于分隔列，`\\` 用于换行

$$
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
$$

$$
\begin{align}
x + y &= 5 \\
2x - y &= 1
\end{align}
$$

## GitHub Emoji

:smile:, :octocat:
