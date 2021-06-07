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
| [PAC1921-1-AIA-TR] | U2 | Power monitoring | 0.81 | 1 | [Power Monitor Search] |
| [BD9E302EFJ-E2] | U3 | DCDC Regulator | 0.89 | 1 | [Buck Converter Search] |
| [1217AS-H-8R2M=P3] | L2 | Inductor 8.2µH | 0.74 | 1 | [Inductor Search] |
| [LMK316ABJ476ML-T] | C12 / C_out | Output Capacitor 47µF | 0.51 | 1 | [47µF 10V Capacitor Search] |
| [GMK316BJ106KL-T] | C8 / C_in | Input Capacitor 10µF | 0.31 | 1 | [10µF 35V Capacitor Search] |
| [GMK107BJ104KAHT] | C9, C10 / C_in_bypass, C_boot | Input Bypass Capacitor 0.1µF, Boot Capacitor 0.1µF | 0.09 | 2 | [0.1µF 35V Capacitor Search] |
| [ERJ-3EKF5493V] | R7 / R_fbt (R1) | Voltage divider 549 kOhm | 0.08 | 1 | [549 kOhm Resistor] |
| [ERJ-3EKF1023V] | R8 / R_fbb (R2) | Voltage divider 102 kOhm | 0.08 | 1 | [102 kOhm Resistor] |
| [CC0603JRNPO9BN150] | C13 / C_fb | DCDC feedback network | 0.08 | 1 | [15pF 10V Capacitor Search] |
| [CL10B562KB8NNNC] | C11 / C_comp | DCDC phase compensation | 0.08 | 1 | [5600pF Capacitor Search] |
| [LG R971-KN-1] | D2 | 5.1V Supply Status LED | 0.22 | 1 | N/A |
| [RL0816T-R010-F] | R9 | Shunt resistor 0.01 Ohm | 0.37 | 1 | [0.01 Ohm Resistor] |
| [RC0603FR-0716K2L] | R6 | DCDC phase compensation | 0.08 | 1 | [16.2kOhm Resistor Search] |
| [FDS4435BZ] | Q3 | V<sub>in</sub> reverse polarity protection | 0.55 | 1 | [Vin Reverse Polarity Protection Search] |
| [BCM857BS-7-F] | Q1 |  | 0.26 | 1 |  |
| [TSM500P02CX RFG] | Q2 |  | 0.64 | 1 |  |
| 47k 0603 resistor |  |  |  |  |  |
| 10k 0603 resistor |  |  |  |  |  |
<!-- TODO: Split into multiple BOMs, with more specific data -->




[PAC1921-1-AIA-TR]: https://www.digikey.fi/product-detail/en/microchip-technology/PAC1921-1-AIA-TR/PAC1921-1-AIA-CT-ND/5452596
[BD9E302EFJ-E2]: https://www.digikey.fi/product-detail/fi/rohm-semiconductor/BD9E302EFJ-E2/BD9E302EFJ-E2CT-ND/6131355
[1217AS-H-8R2M=P3]: https://www.digikey.fi/product-detail/fi/murata-electronics/1217AS-H-8R2M-P3/490-14060-1-ND/6205785
[LMK316ABJ476ML-T]: https://www.digikey.fi/product-detail/en/taiyo-yuden/LMK316ABJ476ML-T/587-3428-1-ND/4157517
[GMK316BJ106KL-T]: https://www.digikey.fi/product-detail/en/taiyo-yuden/GMK316BJ106KL-T/587-2484-1-ND/2230350
[GMK107BJ104KAHT]: https://www.digikey.fi/product-detail/en/taiyo-yuden/GMK107BJ104KAHT/587-3357-1-ND/4157244
[LG R971-KN-1]: https://www.digikey.fi/product-detail/fi/osram-opto-semiconductors-inc/LG-R971-KN-1/475-1410-1-ND/1802598
[RL0816T-R010-F]: https://www.digikey.fi/product-detail/en/susumu/RL0816T-R010-F/408-1404-1-ND/2734782
[ERJ-3EKF1023V]: https://www.digikey.fi/product-detail/en/panasonic-electronic-components/ERJ-3EKF1023V/P102KHCT-ND/198113
[ERJ-3EKF5493V]: https://www.digikey.fi/product-detail/en/panasonic-electronic-components/ERJ-3EKF5493V/P549KHCT-ND/198438
[CL10B562KB8NNNC]: https://www.digikey.fi/product-detail/en/samsung-electro-mechanics/CL10B562KB8NNNC/1276-2091-1-ND/3890177
[CC0603JRNPO9BN150]: https://www.digikey.fi/product-detail/en/yageo/CC0603JRNPO9BN150/311-1060-1-ND/302970
[RC0603FR-0716K2L]: https://www.digikey.fi/product-detail/en/yageo/RC0603FR-0716K2L/311-16-2KHRCT-ND/729914
[FDS4435BZ]: https://www.digikey.fi/product-detail/en/on-semiconductor/FDS4435BZ/FDS4435BZCT-ND/1305829
[BCM857BS-7-F]: https://www.digikey.fi/product-detail/en/diodes-incorporated/BCM857BS-7-F/BCM857BS-7-FDICT-ND/5801284
[TSM500P02CX RFG]: https://www.digikey.fi/product-detail/en/taiwan-semiconductor-corporation/TSM500P02CX-RFG/TSM500P02CXRFGCT-ND/7360424
[]


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
- Packaging: Cut Tape (CT), Tube, or another relevant packaging format

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
    - Voltage Rating: 35V (25V would be too low to account for component degrading with age with our requirement of 24V max input voltage) on the input side
- Optional:
    - Temperature Coefficient: [X5R]

[X5R]: https://en.wikipedia.org/wiki/Ceramic_capacitor

#### Output Capacitors

[2700pF 10V Capacitor Search]: https://www.digikey.fi/short/8q3v8r2d
[15pF 10V Capacitor Search]: https://www.digikey.fi/short/vwb52970

[47µF 10V Capacitor Search]: https://www.digikey.fi/short/fvwb9mfv



- Category: Capacitors > Ceramic Capacitors
- Required:
    - Capacitance: Specific for each use
    - Voltage Rating: At least 10V (6.3V would be too low to account for component degrading with age) on the output side
- Optional:
    - Temperature Coefficient: [X5R]

<!-- Tell where to find the ESR rating of the output capacitor -->

#### Shunt Resistor

[0.01 Ohm Resistor]: https://www.digikey.fi/short/hnhw538w

- Category: Resistors > Chip Resistor - Surface Mount
- Required:
    - Resistance: 0.01 Ohm
    - Tolerance: +-1%
    - Power (Watts): >= (3A)^2 * 0.01 Ohm = 0.090 W

#### Voltage Selection Resistors

[102 kOhm Resistor]: https://www.digikey.fi/short/zbdmwr0p
[549 kOhm Resistor]: https://www.digikey.fi/short/j9m3hc83

- Category: Resistors > Chip Resistor - Surface Mount
- Required:
    - Resistance: 102 and 549 kOhm, respectively
    - Tolerance: +-1%

#### DCDC Compensation
- Category: Capacitors > Ceramic Capacitors
- Required:
    - Capacitance: Specific for each use
    - Voltage Rating: 10V (6.3V would be too low given a +-20% error margin) on the output side
- Optional:
    - Temperature Coefficient: [X5R]

[16.2kOhm Resistor Search]: https://www.digikey.fi/short/20n2pq25
[5600pF Capacitor Search]: https://www.digikey.fi/short/jvfmbz4m


#### Input Voltage Reverse Polarity Protection
##### P-Channel MOSFET
Requirements:
* Drain-Source voltage V<sub>DS</sub> >= 24V
* minimize R<sub>DS</sub>(on) in the range V<sub>GS</sub> in [12V, 24V]
* Absolute maximum Gate-Source voltage should preverably be >= 24V. Alternatively use a zener diode to limit V<sub>GS</sub>, but make sure that R<sub>DS</sub>(on) is low at at that V<sub>GS</sub> value.

Low part count is preferred so a single larger +- 25V V<sub>GS</sub> tolerant package was chosen.

[Vin Reverse Polarity Protection Search]: https://www.digikey.fi/products/en/discrete-semiconductor-products/transistors-fets-mosfets-single/278


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
