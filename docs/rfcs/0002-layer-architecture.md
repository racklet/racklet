# RFC-0002: Layer Architecture

[![hackmd-github-sync-badge](https://hackmd.io/HYXkw0gMTSia7-Da14GLpQ/badge)](https://hackmd.io/HYXkw0gMTSia7-Da14GLpQ)

<a href="0002-layer-architecture.pdf" target="_blank" rel="noopener" class="print-pdf">Download as PDF</a> (for docs.racklet.io)

[TOC]

## RFC Metadata

**Authors** (in alphabetical order):

- Dennis Marttinen, [@twelho](https://github.com/twelho)
- Lucas Käldström, [@luxas](https://github.com/luxas)

**Status** (as defined [here]): `Provisional`

[here]: https://github.com/kubernetes/enhancements/blob/46b95331113de10ca20a11eb41a0131c88bca966/keps/NNNN-kep-template/kep.yaml#L9

**Creation Date**: `2021-04-15`

**Last Updated**: `2021-06-11`

**RFC Handle**: `0002-layer-architecture`

**Initial Pull Request**: [racklet/racklet#20](https://github.com/racklet/racklet/pull/20)

**Tracking Issue**: [racklet/racklet#21](https://github.com/racklet/racklet/issues/21)

## Summary

_One paragraph explanation of the feature._

This RFC describes the overall Racklet architecture, its defining layers, and requirements for each such layer, derived from [RFC-0001]. For each layer the defining components are described at a high level (avoiding implementation details). The compnoents are associated with their role and five highlighted key requirements from the values and user goals of [RFC-0001].

[RFC-0001]: 0001-high-level-architecture.md

## Motivation

_Why are we doing this? What use cases does it support? What is the expected outcome?_

With this RFC we aim to clearly define the layers Racklet consists of to provide a clear overview of the system for all contributors and maintainers. Additionally this document concisely presents the techniques and technologies used in the various layers to achieve the goals stated in [RFC-0001]. The textual and tabular representation provided here is expected to be augmented by graphical visualizations of the architecture.

**TODO**: Embed the graphics into this document when they're ready.

### Goals

_What is in scope for this work?_

- Define well-known layers of Racklet.
- Describe the requirements for each layer.
- Describe roughly how to be "Racklet conformant" and what the differences are between Racklet and other similar alternatives.

### Non-Goals

_What is out of scope for this work?_

- Describe the details and/or technical implementations of the various layers. See the detailed RFCs for the layers if looking for that information.
- Cover every minor component or implementation-specific components, this RFC is designed to only give an overview.

## Proposal

_This is the technical portion of the RFC. Explain the design in sufficient detail that:_

- _Its interaction with other features is clear._
- _It is reasonably clear how the feature would be implemented._
- _Corner cases are dissected by example._

_The section should return to the examples given in the guide-level explanation below, and explain more fully how the detailed proposal makes those examples work._

Racklet is divided into 5 distinct layers, from lowest-level to highest-level:

1. **Structural**
2. **Electrical**
3. **Firmware**
4. **System Software**
5. **User Software**

There is some overlap between these defined layers, mostly due to individual components contributing to multiple layers, but we aim to keep a clear distinction in this definition. If for example a microcontroller is part of both the electrical and firmware layer, the electrical layer only considers its electical properties and the firmware layer only its firmware.

The architecture is designed with the layers and their interaction as the primary focus. The requirements of a layer drive the design of the layer below it, which aims to satisfy the dependencies according to the values and user goals of the project. The layers are described here in reverse order (layer 5 first), since the highest layer starts the dependency chain by directly fulfilling the user goals.

### 5. User Software layer

**Summary**: The user software layer should allow the user to schedule workloads of choice using either containers or VMs. There should be an accessible and observable graphical user interface in place for the user to monitor and manage the Racklet system and workloads.

**Goals**:
- Enable the user to observe and manage a Racklet cluster
- Enable easy deployment of container/VM workloads
- (Optionally) make a Kubernetes cluster accessible for the user

**Layer components**:

| Component                     | Role                                             | Key Requirements                                                                                        |
| -------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| **VM image building automation** | Define and run VMs declaratively                 | [Improve status quo], [Openness], [Declarative management], [Documentation], [Fast reconfiguration]     |
| **Kubernetes VM image**          | Consume/use a Kubernetes cluster                 | [De-facto standards], [Declarative management], [Loose coupling], [Upgradability], [Utilize Kubernetes] |
| **Racklet Dashboard**            | Monitor rack and cluster state, deploy workloads | [Security by design], [Declarative management], [Open source], [Portability], [Observability]           |

### 4. System Software layer

**Summary**: The system software layer is responsible for enabling the container/VM solutions of the user software layer. There should be a hypervisor in place for the virtual machines and a container orchestration solution ([Kubernetes]) for container workloads. Kubernetes is also leveraged for orchestrating the Racklet rack and performing managemental operations in a declarative fashion.

**Goals**:
- Support running containers/VMs securely and scalably
- Be fully declaratively configured using version control
- Enable secure communications inside the cluster

**Layer components**:

| Component                          | Role                                           | Key Requirements                                                                                                |
| ---------------------------------- | ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **System Kubernetes installation** | Run container workloads, perform management    | [Declarative management], [Consistency], [Modular design], [Portability], [Loose coupling]                      |
| **Hypervisor operating system**    | Run VM workloads, enable kernel-level security | [Defense in depth], [De-facto standards], [Declarative management], [Raspberry Pi compatibility], [Portability] |
| **[CNI] compliant networking**     | Network the Racklet cluster compute nodes      | [Security by design], [No old/insecure protocols], [Openness], [Observability], [End-to-end encryption]         |
| **GitOps tooling**                 | Declarative management of the Racklet stack    | [Improve status quo], [De-facto standards], [Declarative management], [Observability], [Auto-upgradability]     |

[Kubernetes]: https://kubernetes.io/
[CNI]: https://github.com/containernetworking/cni

### 3. Firmware layer

**Summary**: The firmware helps in securely booting and configuring Racklet compute, for example it is declaratively managed and performs cryptographic verification of payloads to boot. The firmware should also help with collecting hardware observability data and telemetry for monitoring and debugging.

**Goals**:

- Enable secure access to the declarative configuration in Git
- Verify payloads to be booted by the compute
- Enable debugging and observability of the hardware and compute
- Store keys and signatures for the above layers

**Layer components**:

| Component                                | Role                                                                         | Key Requirements                                                                                                        |
| ---------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **[u-root] based bootstrap environment** | Secure Git access, firmware updates and payload booting                      | [Security by design], [Improve status quo], [Open source], [Secure updates], [Zero-trust network boot]                  |
| **BMC firmware**                         | Compute booting and debugging, key and signature storage for software layers | [Security by design], [No old/insecure protocols], [Declarative management], [Debuggability], [One-time hardware setup] |
| **RMC firmware**                         | Rack hardware control and observability, e.g. fans                           | [Openness], [Declarative management], [Loose coupling], [Observability], [Secure updates]                               |

*[BMC]: Baseboard Management Controller
*[RMC]: Rack Management Controller

[u-root]: https://u-root.org/

### 2. Electrical layer

**Summary**: The electrical layer backs the power delivery and physical networking requirements of the compute and provides a means to run the firmware on the BMC and RMC (microcontrollers).

**Goals**:

- Provide power for all components in a Racklet rack
- Provide a physical networking device for the software layer
- Provide a means to run the firmware for the compute and rack

**Layer components**:

| Component          | Role                                                          | Key Requirements                                                                                                            |
| ------------------ | ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **BMC PCB**        | Host the BMC microcontroller and deliver power to the compute | [Open Source], [Reproducible PCBs], [Modular design], [Raspberry Pi compatibility], [Energy monitoring]                     |
| **Backplane PCB**  | Rack level power distribution and inter-BMC connectivity      | [Common off-the-shelf parts], [Reproducible PCBs], [Physical portability], [Hot swappability], [Upgradability]              |
| **Network switch** | Provides networking for the rack (and cluster)                | [De-facto standards], [Common off-the-shelf parts], [Sensible rack cost], [Physical portability], [Commodity power and I/O] |

### 1. Structural layer

**Summary**: The structural layer consists of physical components that form the structure of the Racklet rack. The structural layer enables Racklet to be compact, modular and easily transportable. The rack consists of a casing that hosts the backplane, network switch and slots for slide-in trays. The compute with its storage is attached to modular compute trays, that have matching rails for the slide-in slots in the rack.

**Goals**:

- Provide a rigid structure for hosting all components
- Enable component hot-swap and modularity

**Layer Components**:

| Component    | Role                                                                     | Key Requirements                                                                                      |
| ------------ | ------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Compute tray | Enable mounting of a compute unit in a hot-swappable and modular way     | [Open source], [3D printed parts], [Modular design], [Raspberry Pi compatibility], [Hot swappability] |
| Rack case    | Contain the network switch, a power backplane and multiple compute trays | [Open source], [3D printed parts], [Modular design], [Sensible rack cost], [Physical portability]     |

<!-- Links to Racklet values described in RFC-0001 -->
<!-- Security -->
[Security by design]:         0001-high-level-architecture.html#subvalue-security-by-design
[No old/insecure protocols]:  0001-high-level-architecture.html#subvalue-no-old-insecure-protocols
[Improve status quo]:         0001-high-level-architecture.html#subvalue-improve-status-quo
[Defense in depth]:           0001-high-level-architecture.html#subvalue-defense-in-depth

<!-- Interoperability -->
[Openness]:                   0001-high-level-architecture.html#subvalue-openness
[De-facto standards]:         0001-high-level-architecture.html#subvalue-de-facto-standards
[Declarative management]:     0001-high-level-architecture.html#subvalue-declarative-management
[Consistency]:                0001-high-level-architecture.html#subvalue-consistency

<!-- Accessibility / Reproducibility -->
[Open source]:                0001-high-level-architecture.html#subvalue-open-source
[Common off-the-shelf parts]: 0001-high-level-architecture.html#subvalue-common-off-the-shelf-parts
[3D printed parts]:           0001-high-level-architecture.html#subvalue-3d-printed-parts
[Reproducible PCBs]:          0001-high-level-architecture.html#subvalue-reproducible-pcbs
[Documentation]:              0001-high-level-architecture.html#subvalue-documentation

<!-- Modularity / Compatibility -->
[Modular design]:             0001-high-level-architecture.html#subvalue-modular-design
[Raspberry Pi compatibility]: 0001-high-level-architecture.html#subvalue-raspberry-pi-compatibility
[Portability]:                0001-high-level-architecture.html#subvalue-portability
[Loose coupling]:             0001-high-level-architecture.html#subvalue-loose-coupling

<!-- Transparency -->
[Observability]:              0001-high-level-architecture.html#subvalue-observability
[Debuggability]:              0001-high-level-architecture.html#subvalue-debuggability
[Energy monitoring]:          0001-high-level-architecture.html#subvalue-energy-monitoring

<!-- Maintainability / Upgradability -->
[Hot swappability]:           0001-high-level-architecture.html#subvalue-hot-swappability
[Upgradability]:              0001-high-level-architecture.html#subvalue-upgradability
[Auto-upgradability]:         0001-high-level-architecture.html#subvalue-auto-upgradability
[One-time hardware setup]:    0001-high-level-architecture.html#subvalue-one-time-hardware-setup

<!-- Affordability -->
[Sensible rack cost]:         0001-high-level-architecture.html#subvalue-sensible-rack-cost

<!-- User goals -->
[Utilize Kubernetes]:         0001-high-level-architecture.html#user-goal-kubernetes
[Fast reconfiguration]:       0001-high-level-architecture.html#user-goal-fast-reconfiguration
[Secure updates]:             0001-high-level-architecture.html#user-goal-secure-updates
[Zero-trust network boot]:    0001-high-level-architecture.html#user-goal-zero-trust-networking
[End-to-end encryption]:      0001-high-level-architecture.html#user-goal-end-to-end-encryption
[Physical portability]:       0001-high-level-architecture.html#user-goal-physical-portability
[Commodity power and I/O]:    0001-high-level-architecture.html#user-goal-commodity-power-io

### Guide-level explanation

Explain the proposal as if it was already a feature of the project and this would be the documentation for that feature.

- Introducing new named concepts.
- Explaining the feature largely in terms of examples.
- If applicable, provide sample error messages, deprecation warnings, or migration guidance.
- If applicable, describe the differences between teaching this to a Racklet administrator versus a Racklet end user.

**TODO**: Mention what is the difference between "reference" implementation and "community" implementations. TBD

These RFCs target a "reference" implementation of Racklet, as envisioned by its authors. The components and key requirements for them are described from the perspective of this reference implementation, and thus "community" implementations of Racklet (e.g. in a different physical form factor) don't need to strictly adhere to the requirements laid out here. A "Racklet compliant" system ultimately only required to follow the [values laid out in RFC-0001] and the loose coupling hardware/software interfaces of the project. That said, it is still advised that variations of Racklet follow the layers, high-level components and key requirements laid out in this document. 

[values laid out in RFC-0001]: 0001-high-level-architecture.html#values

### Risks and Mitigations

What are the risks of this proposal and how do we mitigate.
Think broadly.
For example, consider both security and how this will impact the larger ecosystem.

**TODO**: How to play nicely with the community, the layers are not that fixed, how to avoid a lot of incompatible implementations, ...

The Racklet team aims to adapt to community requirements and adaptations to keep the Racklet ecosystem cohesive. The project has three strategies to mitigate against the risk of the ecosystem fragmenting with incompatible hardware/software implementations of Racklet:

1. *Community contributions and suggestions are taken into account and encouraged.*
    - The project adapts to the usecases of its userbase to avoid community implementations steering different directions.
1. *Loose coupling is leveraged to the greatest possible extent.*
    - All components of Racklet shall depend on each other only through standardized interfaces, which enables the use of alternative implementations following those specifications.
1. *The layer architecture described here is not fixed.*
    - The layers are used to guide the design, but are not fixed bounds that require to be strictly adhered to. For example, a community-made component can be both part of the user software and system software layer without issue. The Racklet team is also open to feedback regarding the layer structure if you have improvement suggestions to the model.

## Rationale and alternatives

- Why is this design the best in the space of possible designs? TODO: Regarding why this layer structure. e.g. why separate firmware and systems software
- What other designs have been considered and what is the rationale for not choosing them? TODO: Why loose coupling instead of fully integrated
- What is the impact of not doing this? TODO: No way to integrate with the community, patch things as you like it (interfaces vs implementations)

As stated in [Risks and Mitigations](#risks-and-mitigations), Racklet is (one of) the first of its kind with regards to its specification-first architecture. The initial layer separation presented here is the result of an iterative thought process by the core Racklet authors. The five layers are chosen to clearly separate roles and responsibilities of components, without going into too much detail (too many layers) or causing excessive overlap (too few layers). Firmware and system software are separated to achieve loose coupling and clear, secure communication between them. User software is separated from system software to define a border between software mostly provided by the Racklet project and external software that the user introduces (workloads).

[Loose coupling] plays a very important role in the architecture presented here. Racklet could have been designed as a fully integrated system with implementations that are strictly defined by the project, but while this potentially could make the system more compact and simple, it also faces many drawbacks that make it incompatible with the values and goals of the project. For example, Racklet relies heavily on various different projects in the Open Firmware and Cloud Native ecosystems, many of which evolve quickly and provide alternative implementations complying to standard APIs. We want Racklet to be accessible, transparent and modular, which means supporting a wide variety of hardware, and enabling user customization to a great extent. If loose coupling is implemented properly, we believe that the standardized architecture presented here will be relatively simple to maintain and extend, and community-built Racklet solutions will also be able to use the modules and different software implementations effortlessly. In summary, to fulfill the values defined in [RFC-0001] and to avoid ecosystem fragmentation the Racklet project aims to provide interfaces, not implementations.

## Prior art

Discuss prior art, both the good and the bad, in relation to this proposal.
A few examples of what this can include are:

- For community proposals: Is this done by some other community and what were their experiences with it?
- For other teams: What lessons can we learn from what other communities have done here?
- Papers: Are there any published papers or great posts that discuss this? If you have some relevant papers to refer to, this can serve as a more detailed theoretical background.

This section is intended to encourage you as an author to think about the lessons from other projects and provide readers of your RFC with a fuller picture.
If there is no prior art, that is fine - your ideas are interesting to us regardless of whether they are brand new or adaptations from other projects.

TODO: Explain what is the difference between this try and prior RPi clusters.

At the time of Racklet creation the history of Raspberry Pi (and other SBC) based cluster computers is already very rich. Various private persons, educational insistutes and companies have come up with a wide variety of designs (**TODO: Examples**) for different use cases for at least the past 10 years. What sets Racklet apart from these mostly one-off implementations is it's **specification**. Instead of deriving a specification from some implementation, Racklet as a system is *primarily* defined as a set of RFC documents. This specification is intended to define a **standardized** way to build a miniature compute cluster, from the lowest-level hardware details up to a state-of-the-art software stack. Since the specification is defined from the ground up, we prioritize basing it on the most _secure_ and _modern_ technologies available today, essentially merging the core concepts of prior SBC cluster computer implementations with the state of the art security and fleet management models of large-scale cloud providers.

*[SBC]: Single Board Computer

## Unresolved questions

- What parts of the design do you expect to resolve through the RFC process before this gets merged?
- What parts of the design do you expect to resolve through the implementation of this feature before stabilization? TODO: All details in their specific RFCs. In that process this RFC might also be updated.
- What related issues do you consider out of scope for this RFC that could be addressed in the future independently of the solution that comes out of this RFC? TODO: Might have an other RFC targeting "Racklet conformance" specifically for community implementations.

The architecture described in this document is prone to encounter changes as the detailed RFCs describing individual components/layers are established. It is also unclear if this particular layered architecture with the chosen high-level components is optimal, and thus the reference implementation will likely influence the structure here once it is better known what works and what doesn't.

Racklet is also a complex system, and this document in its current state can likely not provide the full picture of the architecture to an unfamiliar reader. To combat this, additional graphical elements such as architecture diagrams should be embedded into this document in a future revision (**TODO**).

The concept of "Racklet conformance" briefly disussed in [Risks and Mitigations](#risks-and-mitigations) is not expanded upon here, but might warrant its own RFC specifically for community implementations.

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

TODO: The layer definitions will probably evolve from community feedback and project growth.

The layer definitions presented here are expected to evolve with the project. This document serves as a starting point for discussion, and records the current consensus. In the future the scope of this document might also include a thorough introduction to the architecture for newcomers to the project, as well as improved reasoning for particular high-level architectural decisions and how they are derived.

## Implementation History

Major milestones in the lifecycle of a RFC should be tracked here.
Major milestones might include:

- `2021-MM-DD-FIXME`: This RFC has been accepted.
