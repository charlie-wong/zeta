# Introduction

<style>
  .zeta-version {
    position: absolute;
    right: 20px;
    top: 60px;
    background-color: var(--theme-popup-bg);
    border-radius: 8px;
    padding: 2px 5px 2px 5px;
    border: 1px solid var(--theme-popup-border);
    font-size: 0.9em;
  }
</style>

<div class="zeta-version">
Version: v1.2.3
</div>

[mdBook](https://rust-lang.github.io/mdBook/index.html) is a command line tool to create a clean,
easily navigable books with Markdown. [mdBook Guide](https://github.com/rust-lang/mdBook/tree/master/guide)
is a good sample for beginners and it can be extended with
[community-developed plugins](https://github.com/rust-lang/mdBook/wiki/Third-party-plugins).

```bash
# https://rust-lang.github.io/mdBook/index.html
cargo install mdbook

# https://github.com/joshrotenberg/mdbook-lint
cargo install mdbook-lint

# https://github.com/badboy/mdbook-mermaid
cargo install mdbook-mermaid
# https://github.com/dylanowen/mdbook-graphviz
cargo install mdbook-graphviz

mdbook init --theme --ignore=none --title="Book Title"

mdbook build path/to/book # build the book
mdbook serve path/to/book # boot live server

# PC & phone connect to the same Wifi, view via mobile
mdbook serve -n $(hostname -I | cut -d ' ' -f 1)
```

## Contributing

**zeta** is free and open source. You can find the source code on [GitHub][repoURL], issues
and feature requests can be posted on the [GitHub issue tracker][issueURL]. **zeta** relies on
the community to fix bugs and add new features: if you would like to contribute, please read the
[CONTRIBUTING][contributeURL] guide and consider opening a [pull request][pullRequestURL].

## License

The **zeta** source and documentation are released under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

[repoURL]:        https://github.com/charlie-wong/zeta
[issueURL]:       https://github.com/charlie-wong/zeta/issues
[pullRequestURL]: https://github.com/charlie-wong/zeta/pulls
[contributeURL]:  https://github.com/charlie-wong/zeta/blob/trunk/docs/CONTRIBUTING.md
