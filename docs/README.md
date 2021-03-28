# Racklet mdBook setup

`docs.racklet.io` is powered by technologies such as Rust's [`mdbook`], GitHub Pages, GitHub Actions and a bit of Git LFS.

The source of the documentation is the [`docs/`] folder of the main Racklet repository.
If you find typos or corrections you'd like to make, feel free to create a Pull Request to fix this!
(See also the [contribution guidelines]).

[`mdbook`]: https://github.com/rust-lang/mdBook
[`docs/`]: https://github.com/racklet/racklet/tree/main/docs
[contribution guidelines]: CONTRIBUTING.md

## High-level automation overview

When a new PR is submitted, documentation is automatically (thanks to [this CI script]) generated from Markdown to HTML using `mdbook`. The "rendered" HTML is stored in the `./book/html` folder of the repository.

When a PR is merged to the `main` branch, GitHub Actions kicks off the [deploy script] which

- downloads relevant Git LFS content from the origin (in order to upload e.g. PNGs and SVGs as-is)
- renders the HTML based on the source Markdown
- renders nicely-formatted PDFs for all [RFCs](rfcs/README.md)
- creates a completely new Git repo (`git init`), and commits the output HTML and PDFs in the "root commit"
- finally, force-pushes this "root commit (that has Git LFS disabled) to the `gh-pages` branch in the `racklet` repo

[this CI script]: https://github.com/racklet/racklet/blob/main/.github/workflows/pages-ci.yml
[deploy script]: https://github.com/racklet/racklet/blob/main/.github/workflows/pages-deploy.yml

This flow has many benefits, including but not limited to:

- The ability to vet documentation PRs before they are merged (CI) (auto-publication of PRs is out of scope)
- Automatical deployment to the `docs.racklet.io` site with minimal hassle (just merge PRs, no need to host any server)
- The ability for users to download print-optimized PDF versions of the RFCs.
- The ability to write high-level, easy Markdown, but render fairly advanced document features (e.g. Table of Contents, Footnotes, Math Equations, etc.)
- The ability to integrate e.g. [HackMD] for collaborative editing before a PR is merged.
- The ability to use Git LFS for all history and revision on the `main` branch (to use as little space as possible) but **not** use Git LFS on the `gh-pages` branch, as GitHub Pages does not support LFS. As the `gh-pages` branch always has just one commit, clones of the repo won't take forever thanks to [garbage collection in GitHub] ("orphaned" commits seem to be deleted when it is older than 14 days and you are pushing to the repo). We might have to also confirm some time in the future that this garbage collection actually does happen.

[garbage collection in GitHub]: https://github.community/t/does-github-ever-purge-commits-or-files-that-were-visible-at-some-time/1944/4
[HackMD]: https://hackmd.io

## Contributing to the documentation

If you are improving the documentation locally, you need [Docker] and [Make] installed.

[Docker]: https://docker.io
[Make]: https://www.gnu.org/software/make/

The following commands are available to you:

```console
make help
```

In particular, there are four commands of importance for documentation:

- `make docs`: This renders the documentation into HTML in the `book` folder
- `make docs-serve`: This renders the documentation, reloads it as you edit files, and serves the book at `http://localhost:8080`
- `make generate-pdfs`: This generates PDFs from the rendered HTML, for the RFCs. These PDFs should be checked into the Git repo. They are also accessible from the mdBook by changing the suffix from `html` to `pdf`
  - For example, to download RFC-0001 (at `https://docs.racklet.io/rfcs/0001-high-level-architecture.html`) in PDF format, go to `https://docs.racklet.io/rfcs/0001-high-level-architecture.pdf`.
  - TODO: In the future, we might consider automation that automatically creates a link in the Markdown file to its corresponding PDF.
- `make tidy`: This target should be run before committing modifications. It is used to reformat code, text and running lightweight linters. It might, under certain circumstances, also be a no-op.
- `make autogen`: This target runs more heavy-weight autogeneration tasks like generating PDFs, images, code or dependency trees. It should be run once per PR. Depending on the repository and context, the CI might also run this step, and automatically push a new commit to your branch.

### "Special" features of our mdBook

Here a set of noteworthy features in this mdBook are listed. The "general" ones are listed over at [mdBook-specific features]

[mdBook-specific features]: https://rust-lang.github.io/mdBook/format/mdbook.html

#### Table of Contents (ToC) marker

If you are writing a long document, you might have the need for a table of contents. By just adding a `[TOC]` marker anywhere in your text, you will automatically get a fully-populated table of contents in the book. Note that this marker is understood by HackMD as well, so it'll also show up there nicely.

#### Footnotes

There is support for [Markdown footnotes] in `mdBook`, but it comes with a couple of caveats:

- The footnote HTML is generated exactly at the place it is in the document. This is different from some node.js-based implementations like [Remarkable], which automatically moves the footnote to the end of the document.
- The footnote index is generated in the order the footnote appears in the document. In other words, the first footnote reference in the document might be something other than 1, entirely dependent on how many other definitions preceded the definition the reference points to.
- There is no "backlinking" from the definitions to the references, like the example in [Markdown footnotes] (and as is implemented in [Remarkable])

For now, the workaround is to create a section at the end of the document (separated by `---` from the rest of the document), where all the footnote definitions are stored. One needs to sort them manually in the order they are referenced. This could be automated in the future.

[Markdown footnotes]: https://www.markdownguide.org/extended-syntax#footnotes
[Remarkable]: https://github.com/jonschlinkert/remarkable

#### LaTeX math expressions

It should be possible to use LaTeX math expressions in our mdBook.

However, the [`mdbook-katex`] plugin isn't present in the Docker container we're currently using, until [Michael-F-Bryan/mdbook-docker-image#8] is resolved. Hence, we can't use the plugin yet.

[`mdbook-katex`]: https://crates.io/crates/mdbook-katex
[Michael-F-Bryan/mdbook-docker-image#8]: https://github.com/Michael-F-Bryan/mdbook-docker-image/pull/8

#### draw.io integration

TODO: Integrate this in the future

#### PlantUML rendering

TODO: Integrate this in the future

#### "Edit me on GitHub" links

Using the [`mdbook-open-on-gh`] plugin, a `Found a bug? Edit this file on GitHub.` link will be added to the end of each page.

[`mdbook-open-on-gh`]: https://crates.io/crates/mdbook-open-on-gh

#### PDF generation

Our objective for the RFCs is to be as close to academic papers as is reasonable, but without the need for writing any LaTeX, which doesn't play well with the GitHub ecosystem, and isn't as contributor-friendly as Markdown.

Hence, we're trying to find a middleground in which we write all our RFCs in `mdBook` form, using Markdown, but with some critical extensions like ToC and footnotes support. Additionally, we want to be able to generate PDFs which

- combine all images, drawings and other visual references in one file (for easy distribution and/or submission)
- preserve formatting/fonts/etc. regardless of viewer
- are fully navigable using internal links, e.g. from the ToC to header elements, inline text to inline text, or footnote references to definitions
- look visually (at least somewhat) pleasing
- are printable, with context of external links to webpages kept

In order to achieve this goal, we have a [dedicated CSS file for print styles], which for example make the link `href` targets visible for links within a footnote (i.e. the "Sources" or "References" section).

Navigation from text to text can be achieved with a normal link and a `span` element as follows:

`[my reference here](#custom-ref)` => `I want to link exactly <span id="custom-ref"></span> here`

Note that the `#custom-ref` must match both places, and is case-sensitive.

What we still would like to improve in the future, is to make a mdBook preprocessor that creates footnotes for all normal links in the document, and refers to them using the webpage title, e.g. as follows:

```markdown
... other text ...

I want to link to [Ethernet].

[Ethernet]: https://en.wikipedia.org/wiki/Ethernet

... other text ...
```

becomes

```markdown
... other text ...

I want to link to [Ethernet][^Ethernet].

[Ethernet]: https://en.wikipedia.org/wiki/Ethernet

... other text ...

---

... other footnote definitions ...

[^Ethernet]: [Ethernet - Wikipedia][Ethernet]

... other footnote definitions ...
```

This would lead to the `https://en.wikipedia.org/wiki/Ethernet` link being visible in the printed PDF, in the footnotes section.

In order to raise awareness that our RFCs actually do have a PDF automatically generated (downloadable from the website or the Git repo), we'd like to add this kind of marker to each RFC:

```html
<a href="0001-high-level-architecture.pdf" target="_blank" rel="noopener" class="print-pdf">Download as PDF</a>
```

This could be made its own mdBook preprocessor as well.

(If you're interested in why we use `rel="noopener"` look at [this StackOverflow answer] and [this Google report].)

Finally, the code for the PDF generation itself is in the [`Makefile`]. This should be made its own mdBook output over time, but for now this is okay. Essentially, it uses a containerized version of Google Chrome to print the generated HTML output of mdBook for the RFC in question.

[dedicated CSS file for print styles]: https://github.com/racklet/racklet/blob/main/.mdbook/print.css
[`Makefile`]: https://github.com/racklet/racklet/blob/main/Makefile
[this StackOverflow answer]: https://stackoverflow.com/a/4425223
[this Google report]: https://sites.google.com/site/bughunteruniversity/nonvuln/phishing-with-window-opener

## Considerations for porting this mdBook flow to another repository

This guide gets you started for integrating a mdBook into a new repository.

1. Create a new, empty GH Pages branch with a `CNAME` file of your custom domain name of choice.
   - For example as follows:

    ```bash
    # This expects you to have set the the CNAME and GITHUB_REPOSITORY environment variables, and have SSH authentication and a name/email set up in git.
    mkdir tmp && cd tmp
    git init
    echo ${CNAME} > CNAME && echo "# Work in Progress" > README.md && git add CNAME README.md
    git commit -m "Register CNAME and README.md"
    git push git@github.com:${GITHUB_REPOSITORY}.git $(git branch --show-current):gh-pages
    ```

2. In GitHub Repository settings, you should hopefully now see `gh-pages` and `/` as your source branch and directory, respectively. The "Custom domain" field should also have picked up the value of your `CNAME` file. If not, correct these fields.
3. Go to your DNS provider, and create a CNAME record from the custom domain you chose, to `<owner>.github.io`, where `<owner>` is either your GitHub user or organization name.
4. In a couple of minutes (depending on how fast your DNS record propagates), you should be able to browse to `http://<custom-domain>`. HTTPS might not yet be enabled. To enforce that, go to the GitHub Repository settings again, and check the "Enforce HTTPS" option. You might have to wait for DNS propagation before this option becomes available.
5. Go to the [mdBook website], and learn the format of `book.toml` and `docs/SUMMARY.md`. You can also use adapted versions from this repository. However, note the caveats below.
6. Copy or adapt parts of the `Makefile` so it fits your needs (e.g. do you need PDF generation or not?). Copy the `.github/workflows/pages-*` files, and the `.mdbook` directory to your repository.
7. Now you should be close to up and running, and can start testing it in CI. One tip is to try deploying to GitHub Pages already from the Pull Request (testing in production, heh) using this configuration in the workflow (temporarily!):

   ```yaml
   on:
     push:
       branches:
       - main
       - my-pr-branch-here    # TODO: Remove me before merging this mdBook PR
   ```

8. When that "deploy" action has completed, you should see your mdBook site live on the internet!

[mdBook website]: https://rust-lang.github.io/mdBook/

### Caveats

- The [`mdbook-katex`] plugin isn't present in the Docker container we're currently using, until [Michael-F-Bryan/mdbook-docker-image#8] is resolved. Hence, we can't use the plugin yet.
- The built-in `index` preprocessor is not used, as it is not updating links to it internally as it should, see [rust-lang/mdBook#984] for context.
- You need to specify your own custom domain in the `cname` field, under the `[output.html]` section.
- You need to change all the basic parameters in `book.toml` (like `authors`, `title`, `description` and `git-repository-url`)
- You might not link to files outside of your "source folder" (specified using `src` in the `[book]` section, `docs` in our case). The workaround we're using is that before `mdbook` is run, we're copying any needed files manually to `docs/`. This is brittle though, as it would not work if any file under `docs/` actually was referring to the file at e.g. top-level. We might need to write our own preprocessor eventually to solve this.
- In order to not make the URL of this documentation file `docs.racklet.io/README.html` (which would be slightly misleading), we working our way around this by having a symlink from `mdbook.md` to `README.md` (so things still show up nicely in GitHub), and reference `mdbook.md` in `SUMMARY.md`. As with the previous note, this is brittle and does not work if this file is referenced internally on the site.

[rust-lang/mdBook#984]: https://github.com/rust-lang/mdBook/issues/984
