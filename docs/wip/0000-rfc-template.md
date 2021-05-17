# WIP-0000: Securing boot process for Racklet

[![hackmd-github-sync-badge](https://hackmd.io/WQoGMcMpR4aDmPkXU4ULLg/badge)](https://hackmd.io/WQoGMcMpR4aDmPkXU4ULLg)

This is a working document regarding how node boot sequence should be secured in Racklet. Essentially the goal is that the payload specified in libgitops can be trusted to be exactly what ends up running on a node. 


Current status:
ask @twelho
- Problem with TrustZone and writable SD Card
    - With SD W perms persistence is trivial
- The EEPROM bootloader is writable, also a problem.
    - Is exploiting this trivial? Are there any PoCs?
    - Still a major problem as there's TFTP boot ability and etc
    - There exists a write protection using a test point (on raspi 3 board) set to HIGH voltage. Requires control from BMC to pull DOWN to be able to update the board.
- SD card must be read only at runtime to avoid persistent malicious software
    - Emulating SD card with BMC can be the root of trust and give the SD card bootloaders to the nodes
    - SD cards can use SPI or SD protocol
        - Both required for specification on card side. Raspi uses SD proto
        - No existing libraries for SD protocol signaling :/
        - Can still be done using a state machine 
        - Note by @Jaakkonen: Could the BMC use a physical SD and just filter the commands instead of emulating full card?
- TPM would only help from the BMC provided bootloader onward
- libgitops flow in the u-root part of LinuxBoot, in order to know what OS image to boot.
- 
    - Use The Update Framework to achieve trusted downloads of the OS image.
- Images are checked with cryptographic signatures
- EEPROM 1st stage bootloader can do USB boot so we could maybe emulate USB instead of SD
- RP2040 has a PIO language, might be of use
- Update procedure:
    - Wiping devices / u-boot bootloader 
    - Communication to BMC can happen via a Raspi proxy (checks commands sent to it with cryptographic checks)
        - Update Framework specifies protocols for updating the keys



Primary focus in terms of hardware:
- Raspberry Pi ecosystem
- RK3288 and RK3399 boards, e.g.
    - Orange Pi RK3399 (orangepi-rk3399)
    - Pine64 RockPro64 (rockpro64-rk3399)
    - Radxa ROCK Pi 4 (rock-pi-4-rk3399)
    - Rockchip Evb-RK3399 (evb_rk3399)
    - NanoPi M4 something

1. Hardware-built-in loader (first-stage)
2. u-boot SPL / Coreboot / start.elf (second-stage)
    - possibility to talk to the TPM for the first time
3. optional: TF-A stuff, integrated into the second-stage bootloader
4. Minimal linux + initramfs => kexec
5. Target OS


Random idea by @luxas:
- First, we need some way to secure the EEPROM of the Raspberry Pi, if at all possible, as this is the highest-privilege escalation path of the system (overwriting the EEPROM firmware is pretty easy)
    - There is some support for locking 


Crude ideas of @Jaakkonen:
- Notes:
    - The Raspberry Pi 3 has unified RAM meaning that ARM TrustZone doesn't really give any value as GPU can access any memory freely.
    - TrustZone could be used on RK3399 or other SoCs with more secure memory model to implement software TPMs/secret services in TrustZone for higher up the stack.
    - TF-A and OP-TEE (Open Portable Trusted Execution Environment) are both maintained by Linaro -> Platforms that support TF-A probably have OP-TEE support too that can be used to run a software TPM.
    - We need to check if there's a library with constant time cryptographic routines for the BMC microcontroller
        - If not, a TPM fixed function crypto hw could be considered for just that.
- Booting with a root of trust and carrying the trust onward
    1. Assume proprietary GPU bootloader blob has no backdoors :D
    2. Read trivial bootloader with signature checking from SD card. For attacker code to not persist data read from SD must be trustworthy (hard write-locked SD card or BMC emulating a read-only SD card)
        - Places the trust on BMC instead of the raspis
    3. Next step (LinuxBoot?) is now loaded from a NAS and its signature is verified.
        - If using a platform with trustworthy TrustZone then a software TPM could be used to track the executed code in a PCRs. A Raspi
    4. Kubernetes node payload is eventually loaded and Raspi joins to it using a secret supplied by BMC
        - The cluster secret can be sealed by known good PCR measurements to forbid nodes with unexpected software to join the cluster.
        - Another option is to use remote attestation like method to detect nodes with unexpected software:
            1. Contact cluster controller, receive nonce
            2. Concat nonce and PCRs, sign hash with a private key. Send this to cluster controller
            3. Verify message against cluster intermediate CA (or maybe even node specific cert if that's known).
            4. Determine whether to allow node to connect to cluster / log the PCRs based on this
- Creating a trustworthy BMC:
    1. At bare minimum the BMC has to hold node specific cluster keys (or ability to create them) and Raspberry Pi bootloader files.
    2. Maybe have a actual hw TPM to store node-specific and BMC specific secrets


Conclusion:
- Rockchip based boards from Pine64 make creating a trusted boot sequence much simpler.
    - BMC can provide all necessary software to fetch specified payload over SPI. No SD card mocks or write protect pin soldering required.
- Raspberry Pi will still be a supported platform for development
    - EEPROM and SD card contents must be trusted.
    - Codebase can be shared from u-boot onwards
    - TODO: Maybe write a blog detailing how to make a Raspberry Pi boot securely under supervisor (BMC) and document our findings and thougths on creating a SD card state machine, soldering write protect pins, researching UART output, ARM TrustZone problems and etc























<!--

<!-- Remember to add autogenerated HackMD badge here. See the [README](README.md) for more details. -- >

<!-- The TOC marker below will translate into an automatically-generated table of contents when generated
by `mdBook` and when edited online in HackMD. -- >

[TOC]

<!-- This link will offer the option to download this RFC as a PDF. -- >

<a href="0000-rfc-template.pdf" target="_blank" rel="noopener" class="print-pdf">Download as PDF</a>

## RFC Metadata

**Authors** (in alphabetical order):

- Author Name, [@Author_GitHub_Handle](https://github.com/Author_GitHub_Handle)
- Foo Bar, [@Foo_Bar](https://github.com/Foo_Bar)

**Status** (as defined [here]): `Provisional`

[here]: https://github.com/kubernetes/enhancements/blob/master/keps/0001-kubernetes-enhancement-proposal-process.md#kep-metadata

**Creation Date**: `YYYY-MM-DD`

**Last Updated**: `YYYY-MM-DD`

**RFC Handle**: `rfc-template` (should match the file name, as `NNNN-{rfc_handle}`, but without the `.md` suffix)

**Initial Pull Request**: [racklet/racklet#NNNN](https://github.com/racklet/racklet/pull/NNNN)

**Tracking Issue**: [racklet/racklet#NNNN](https://github.com/racklet/racklet/issues/NNNN)

**Version Number**: `v1.X.Y` <!-- Follows SemVer  -- >

## Summary

One paragraph explanation of the feature.

## Motivation

Why are we doing this? What use cases does it support? What is the expected outcome?

### Goals

What is in scope for this work?

### Non-Goals

What is out of scope for this work?

## Proposal

This is the technical portion of the RFC. Explain the design in sufficient detail that:

- Its interaction with other features is clear.
- It is reasonably clear how the feature would be implemented.
- Corner cases are dissected by example.

The section should return to the examples given in the guide-level explanation below, and explain more fully how the detailed proposal makes those examples work.

### Values

Describe what values does the proposed feature reflect. See [RFC-0001](0001-high-level-architecture.md).

### User stories

Explain what is the use case of the proposed feature and how it would benefit the user.

### Guide-level explanation

Explain the proposal as if it was already a feature of the project and this would be the documentation for that feature.

- Introducing new named concepts.
- Explaining the feature largely in terms of examples.
- If applicable, provide sample error messages, deprecation warnings, or migration guidance.
- If applicable, describe the differences between teaching this to a Racklet administrator versus a Racklet end user.

### Risks and Mitigations

What are the risks of this proposal and how do we mitigate.
Think broadly.
For example, consider both security and how this will impact the larger ecosystem.

## Drawbacks

Why should we *not* do this? Consider at least one drawback.

## Rationale and alternatives

- Why is this design the best in the space of possible designs?
- What other designs have been considered and what is the rationale for not choosing them?
- What is the impact of not doing this?

## Prior art

Discuss prior art, both the good and the bad, in relation to this proposal.
A few examples of what this can include are:

- For community proposals: Is this done by some other community and what were their experiences with it?
- For other teams: What lessons can we learn from what other communities have done here?
- Papers: Are there any published papers or great posts that discuss this? If you have some relevant papers to refer to, this can serve as a more detailed theoretical background.

This section is intended to encourage you as an author to think about the lessons from other projects and provide readers of your RFC with a fuller picture.
If there is no prior art, that is fine - your ideas are interesting to us regardless of whether they are brand new or adaptations from other projects.

## Unresolved questions

- What parts of the design do you expect to resolve through the RFC process before this gets merged?
- What parts of the design do you expect to resolve through the implementation of this feature before stabilization?
- What related issues do you consider out of scope for this RFC that could be addressed in the future independently of the solution that comes out of this RFC?

## Future possibilities

Think about what the natural extension and evolution of your proposal would
be and how it would affect the project as a whole in a holistic
way. Try to use this section as a tool to more fully consider all possible
interactions with the project in your proposal.
Also consider how this all fits into the roadmap for the project.

This is also a good place to "dump ideas", if they are out of scope for the
RFC you are writing but otherwise related.

If you have tried and cannot think of any future possibilities,
you may simply state that you cannot think of anything.

Note that having something written down in the future-possibilities section
is not a reason to accept the current or a future RFC; such notes should be
in the section on motivation or rationale in this or subsequent RFCs.
The section merely provides additional information.

## Implementation History

Major milestones in the lifecycle of a RFC should be tracked here.
Major milestones might include:

- The status of the RFC has been changed or another major change to the RFC has been accepted.
- The first Racklet version including an initial version of the RFC is released.
- The Racklet version where the RFC graduated to general availability is released.
- The RFC version number has been updated
- The RFC has been retired or superseded.

-->