# Read/write files as the current user
UID_GID=$(shell id -u):$(shell id -g)
# Lock the jfrazelle/dotfiles repo to a specific revision
DOTFILES_REV=e355499a0ac9dff3e2989a6a4c7fa0e2632a3b76
# There's no tty available in CIs commonly, so don't use the -t flag there
TTY_ARGS=-it
ifneq ($(CI),)
TTY_ARGS=-i
endif
RUN_ARGS=$(TTY_ARGS) -u $(UID_GID) --rm

# The generated HTML is written to this directory (we're using more than one output in book.toml)
MDBOOK_OUTPUT=book/html

# This Makefile is self-documented (see the "help" target below). In order to make a target
# show up when running "make help", add two # characters after the target declaration, on the
# same line. Refer to e.g. the help target itself for an example of this looks like.

# When we later have a proper "build" target, that should be the default. For now, we just default to help.
all: help

# Tidy runs lightweight linters, formatters, etc., should be called before committing changes.
tidy: docs ## Run before committing modifications. Used to reformat code, text and run lightweight linters.

# Autogen performs tasks like generating PDFs, images, code or dependency trees. Run once per PR.
autogen: generate-pdfs ## Run once per PR. Used to e.g. generate PDFs, images, code or dependency trees.

# Copy over top-level files that should be part of the mdBook
docs-cp:
	cp CONTRIBUTING.md CODE_OF_CONDUCT.md LICENSE docs
	# Modify relative links to docs/; now that is not needed anymore.
	# TODO: This would actually be make a pretty good preprocessor; a general-purpose preprocessor
	# that is able to include any file in otherwise inaccessible directories, and that can handle file
	# name changes.
	sed "s|(docs/|(|g" README.md > docs/index.md

# Run an mdBook command in a container
docker-mdbook: docs-cp
	# Always use the latest rolling versions to get e.g. security fixes on a rolling schedule without having to
	# constantly update this repo. If this breaks in the CI, it's not very critical, and we'll adapt then.
	docker pull michaelfbryan/mdbook-docker-image:latest
	docker run $(RUN_ARGS) -v $(shell pwd):/book -w /book \
		michaelfbryan/mdbook-docker-image:latest $(MDBOOK_ARGS)

# Build and verify the mdBook. Use PHONY so that make always runs this target although the docs folder is present.
.PHONY: docs
docs: ## Build and verify the mdBook
	$(MAKE) MDBOOK_ARGS=build docker-mdbook
# Build, verify, constantly reload mdBook sources as they change, and start a webserver on localhost.
# Note that the files copied in docs-cp ARE NOT automatically reloaded.
# Inside the container, the mdBook process binds to 0.0.0.0, but outside the container
# it is only available through localhost.
docs-serve: ## Build, verify, reload and host the mdBook at http://localhost:3000
	@echo "NOTE: The mdBook site will be available at http://localhost:3000 (not 0.0.0.0) on your host!"
	# Somehow the mdbook serve in a container doesn't respond to CTRL+C, which is annoying, so here's a workaround
	# Remove/kill the container if it already exists
	docker rm -f mdbook || echo "Already ok, the container does not exist"
	# Start it with --detach-keys=ctrl-c to make it detach for that sequence (not propagating the signal to mdbook)
	$(MAKE) MDBOOK_ARGS="serve --hostname=0.0.0.0" RUN_ARGS="$(RUN_ARGS) --name=mdbook -p 127.0.0.1:3000:3000 --detach-keys=ctrl-c" docker-mdbook
	# ... and once detached, force-kill/remove the (at this point still running) container
	docker rm -f mdbook

chrome-seccomp.json:
	wget https://raw.githubusercontent.com/jfrazelle/dotfiles/$(DOTFILES_REV)/etc/docker/seccomp/chrome.json -O chrome-seccomp.json

# Generate well-formatted PDFs for RFC documents, both for committing in the repo, and for downloading from the mdBook
# TODO: This could make a good mdBook output plugin in the future.
generate-pdfs: docs chrome-seccomp.json ## Generate PDFs for RFCs
	# Always use the latest rolling versions to get e.g. security fixes on a rolling schedule without having to
	# constantly update this repo. If this breaks in the CI, it's not very critical, and we'll adapt then.
	docker pull zenika/alpine-chrome:latest
	# Refer to the great guide at https://github.com/Zenika/alpine-chrome#-the-best-with-seccomp
	for file in $$(find docs/rfcs/*.md | sed "s|docs/||;s|.md||" | grep -v "README"); do \
		docker run $(RUN_ARGS) -e file="$$file" --security-opt seccomp="$(shell pwd)/chrome-seccomp.json" -v "$(shell pwd):/build" -w /build \
		zenika/alpine-chrome:latest --disable-gpu --print-to-pdf-no-header --print-to-pdf="$(MDBOOK_OUTPUT)/$$file.pdf" "$(MDBOOK_OUTPUT)/$$file.html" 1>/dev/null && \
		echo "=> $(MDBOOK_OUTPUT)/$$file.pdf" && \
		cp "$(MDBOOK_OUTPUT)/$$file.pdf" "docs/$$file.pdf" && \
		echo "=> docs/$$file.pdf" \
	; done

# Source: https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/
.PHONY: help
# NOTE: In order for a make target to show up in the help text, it needs to have two # characters after the target
# name, like this help example below:
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
