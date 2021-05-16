# RFC-0004: Compute unit HAT attachment hardware

[![hackmd-github-sync-badge](https://hackmd.io/teQDdcnyQ6KEzBAuJWAn5g/badge)](https://hackmd.io/teQDdcnyQ6KEzBAuJWAn5g)

<!-- The TOC marker below will translate into an automatically-generated table of contents when generated
by `mdBook` and when edited online in HackMD. -->

[TOC]

<!-- This link will offer the option to download this RFC as a PDF. -->

<a href="0004-compute-hat.pdf" target="_blank" rel="noopener" class="print-pdf">Download as PDF</a>

## RFC Metadata

**Authors** (in alphabetical order):
- Dennis Marttinen, [@twelho](https://github.com/twelho)
- Lucas Käldström, [@luxas](https://github.com/luxas)
- Verneri Hirvonen, [@chiplet](https://github.com/chiplet)

**Status** (as defined [here]): `Provisional`

[here]: https://github.com/kubernetes/enhancements/blob/master/keps/0001-kubernetes-enhancement-proposal-process.md#kep-metadata

**Creation Date**: `2021-05-15`

**Last Updated**: `2021-05-15`

**RFC Handle**: `compute-hat`

**Initial Pull Request**: [racklet/racklet#28](https://github.com/racklet/racklet/pull/28)

**Tracking Issue**: [racklet/racklet#15](https://github.com/racklet/racklet/issues/15)

**Version Number**: `v1.0.0`

## Summary

Description of the compute tray HAT hardware.

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

### BOM


| Part Number | Schematic Reference | Purpose | Unit price [€] | Quantity / Board | Search |
| -------- | -------- | -------- | -------- | -------- | --- |
| [PAC1921-1-AIA-TR] | TBD | Power monitoring | 0.81 | 1 | [Power Monitor Search] |
| [BD9E302EFJ-E2] | U3 | DCDC Regulator | 0.89 | 1 | [Buck Converter Search] |
| [1217AS-H-8R2M=P3] | L2 | Inductor 8.2µH | 0.74 | 1 | [Inductor Search] |
| [LMK316ABJ476ML-T] | C12 / C_out | Output Capacitor 47µF | 0.51 | 1 | [47µF 10V Capacitor Search] |
| [LMK063BJ104KP-F] | C10 / C_boot | Boot Capacitor 0.1µF | 0.08 | 1 | [0.1µF 10V Capacitor Search]|
| [GMK316BJ106KL-T] | C8 / C_in | Input Capacitor 10µF | 0.31 | 1 | [10µF 35V Capacitor Search] |
| [GMK107BJ104KAHT] | C9 / C_in_bypass | Input Bypass Capacitor 0.1µF | 0.09 | 1 | [0.1µF 35V Capacitor Search] |
| [ERJ-2RKF5493X] | R7 / R_fbt (R1) | Voltage divider 549 kOhm | 0.08 | 1 | [549 kOhm Resistor] |
| [ERJ-1GNF1023C] | R8 / R_fbb (R2) | Voltage divider 102 kOhm | 0.08 | 1 | [102 kOhm Resistor] |
| [885012006003] | C13 / C_fb | DCDC feedback network | 0.08 | 1 | [15pF 10V Capacitor Search] |
| [RMCF0402FT549K] | C11 / C_comp | DCDC phase compensation | 0.08 | 1 | [2700pF 10V Capacitor Search] |
| [LG R971-KN-1] | LED_GREEN | Status LED | 0.22 | 1 | N/A |
| [ERJ-2LWFR010X] | ??? | Shunt resistor 0.01 Ohm | 0.37 | 1 | [0.01 Ohm Resistor] |
| [] | R6 | DCDC phase compensation ||||

<!-- TODO: Split into multiple BOMs, with more specific data -->


[PAC1921-1-AIA-TR]: https://www.digikey.fi/product-detail/en/microchip-technology/PAC1921-1-AIA-TR/PAC1921-1-AIA-CT-ND/5452596
[BD9E302EFJ-E2]: https://www.digikey.fi/product-detail/fi/rohm-semiconductor/BD9E302EFJ-E2/BD9E302EFJ-E2CT-ND/6131355
[1217AS-H-8R2M=P3]: https://www.digikey.fi/product-detail/fi/murata-electronics/1217AS-H-8R2M-P3/490-14060-1-ND/6205785
[LMK316ABJ476ML-T]: https://www.digikey.fi/product-detail/en/taiyo-yuden/LMK316ABJ476ML-T/587-3428-1-ND/4157517
[LMK063BJ104KP-F]: https://www.digikey.fi/product-detail/en/taiyo-yuden/LMK063BJ104KP-F/587-2241-1-ND/2002939
[GMK316BJ106KL-T]: https://www.digikey.fi/product-detail/en/taiyo-yuden/GMK316BJ106KL-T/587-2484-1-ND/2230350
[GMK107BJ104KAHT]: https://www.digikey.fi/product-detail/en/taiyo-yuden/GMK107BJ104KAHT/587-3357-1-ND/4157244
[LG R971-KN-1]: https://www.digikey.fi/product-detail/fi/osram-opto-semiconductors-inc/LG-R971-KN-1/475-1410-1-ND/1802598
[ERJ-2LWFR010X]: https://www.digikey.fi/product-detail/en/panasonic-electronic-components/ERJ-2LWFR010X/P19181CT-ND/6004536
[ERJ-1GNF1023C]: https://www.digikey.fi/product-detail/en/panasonic-electronic-components/ERJ-1GNF1023C/P122660CT-ND/8342259
[ERJ-2RKF5493X]: https://www.digikey.fi/product-detail/en/panasonic-electronic-components/ERJ-2RKF5493X/P549KLCT-ND/194451
[RMCF0402FT549K]: https://www.digikey.fi/product-detail/en/stackpole-electronics-inc/RMCF0402FT549K/738-RMCF0402FT549KCT-ND/4425019
[885012006003]: https://www.digikey.fi/product-detail/en/w%C3%BCrth-elektronik/885012006003/732-7747-1-ND/5454374


[OLD LMK212BJ106KG-T]: https://www.digikey.fi/product-detail/en/taiyo-yuden/LMK212BJ106KG-T/587-1300-1-ND/931077

<!-- TODO: Voltage rating on the input side must be rated at around 30V --> 
Configured input values:
| Parameter                   |        Value |
|-----------------------------|--------------|
| Frequency                   | 550000       |
| Input voltage               |     24       |
| Maximum current             |      3       |
| Ripple current              |      1       |
| Feedback reference V        |      0.8     |
| Current sense gain          |     20       |
| Error amp transconductance  |      0.00014 |
| C<sub>out</sub> capacitance |      4.7e-05 |
| C<sub>out</sub> ESR         |      0.002   |
| Minimum V<sub>out</sub>     |      5.1     |
| Fast load response          |      1       |
| F<sub>CRS</sub> frequency   |  24000       |
| F<sub>Z</sub> frequency     |   2000       |

Computed results:
| Parameter                     |            Value |
|-------------------------------|------------------|
| Output voltage                |      5.10588     |
| L inductance                  |      7.30842e-06 |
| L saturation A min            |      3.5         |
| Voltage ripple                |      0.00683559  |
| C<sub>1</sub> capacitance     |      1.4495e-11  |
| C<sub>2</sub> capacitance     |      4.92582e-09 |
| R<sub>1</sub> resistance      | 549000           |
| R<sub>2</sub> resistance      | 102000           |
| R<sub>1</sub> + R<sub>2</sub> | 651000           |
| R<sub>3</sub> resistance      |  16155.2         |


### DigiKey Search Lookups

General Search Criteria:

- In stock and Normally Stocking
- RoHS compliant
- Part Status: Active
- Media Available: Datasheet
- Packaging: Cut Tape (CT), Tube, or an other relevant packaging format

#### Power Monitor

[Power Monitor Search]: https://www.digikey.fi/short/23n5pnr7

- Category: Integrated Circuits (ICs) > PMIC - Current Regulation/Management
- Required:
    - Function: Current Monitor or Current/Voltage Monitor
- Optional:
    - An integrated ADC such that measurements can be digitally read
    - Voltage measurement
    - Power average reporting over time

#### Buck Converter

[Buck Converter Search]: https://www.digikey.fi/short/20hmfdt4

- Category: Integrated Circuits (ICs) > PMIC - Voltage Regulators - DC DC Switching Regulators
- Required
    - Package / Case: All names that start with "8-" and "10-", in order to select packages with 8 to 10 pins, as that should be enough for our use-case
    - Current Output: >= 3A. We think the SBC's maximum draw will be around 2A, but to have some headroom for expansion and non-idealities.
    - Voltage Input (Min): <= 12V. This means that the maximum lower voltage must be 12V. This because we want to support voltages between 12V and 24V.
    - Voltage Input (Max): >= 24V. This means that the minimum upper voltage must be 24V.

#### Inductor

[Inductor Search]: https://www.digikey.fi/short/734mr782

<!-- https://www.digikey.fi/short/nj4z939z -->

Search parameters for the inductor:
- Category: Inductors, Coils, Chokes > Fixed Inductors
- Required
    - Inductance: 8.2 µH
    - Current Rating and Saturation Current: >= 4A
- Optional
    - Core Material: Ferrite or Metal
    - Shielding: Shielded
    - Tolerance: +-20%

#### Input Capacitors

[10µF 35V Capacitor Search]: https://www.digikey.fi/short/qw8qp4bd
[0.1µF 35V Capacitor Search]: https://www.digikey.fi/short/j417rzq7

All capacitors (both on input and output side) should be ceramic as per the specifications of the buck converter.

- Category: Capacitors > Ceramic Capacitors
- Required:
    - Capacitance: Specific for each use
    - Voltage Rating: 35V (25V would be too low given a +-20% error margin, and our requirement of 24V max input voltage) on the input side
- Optional:
    - Temperature Coefficient: [X5R]

[X5R]: https://en.wikipedia.org/wiki/Ceramic_capacitor

#### Output Capacitors

[2700pF 10V Capacitor Search]: https://www.digikey.fi/short/8q3v8r2d
[15pF 10V Capacitor Search]: https://www.digikey.fi/short/0ppqb27v

[47µF 10V Capacitor Search]: https://www.digikey.fi/short/fvwb9mfv

[0.1µF 10V Capacitor Search]: https://www.digikey.fi/short/qrm9dtw7


- Category: Capacitors > Ceramic Capacitors
- Required:
    - Capacitance: Specific for each use
    - Voltage Rating: 10V (6.3V would be too low given a +-20% error margin) on the output side
- Optional:
    - Temperature Coefficient: [X5R]

<!-- Tell where to find the ESR rating of the output capacitor -->

#### Shunt Resistor

[0.01 Ohm Resistor]: https://www.digikey.fi/short/4jpz474j

- Category: Resistors > Chip Resistor - Surface Mount
- Required:
    - Resistance: 0.01 Ohm
    - Tolerance: +-1%
    - Power (Watts): >= 3A * (0.01 Ohm)^2 = 0.0003 W

#### Voltage Selection Resistors

[102 kOhm Resistor]: https://www.digikey.fi/short/r0ddd88q
[549 kOhm Resistor]: https://www.digikey.fi/short/m4drpzrh

- Category: Resistors > Chip Resistor - Surface Mount
- Required:
    - Resistance: 102 and 549 kOhm, respectively
    - Tolerance: +-1%




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
