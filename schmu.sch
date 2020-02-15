<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_2" />
        <signal name="XLXN_3" />
        <signal name="XLXN_4" />
        <signal name="XLXN_5" />
        <signal name="x" />
        <signal name="XLXN_7" />
        <signal name="y" />
        <signal name="XLXN_9" />
        <port polarity="Input" name="x" />
        <port polarity="Input" name="y" />
        <port polarity="Output" name="XLXN_9" />
        <blockdef name="nand2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="216" y1="-96" y2="-96" x1="256" />
            <circle r="12" cx="204" cy="-96" />
            <line x2="64" y1="-48" y2="-144" x1="64" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
        </blockdef>
        <block symbolname="nand2" name="XLXI_1">
            <blockpin signalname="y" name="I0" />
            <blockpin signalname="x" name="I1" />
            <blockpin signalname="XLXN_1" name="O" />
        </block>
        <block symbolname="nand2" name="XLXI_3">
            <blockpin signalname="XLXN_1" name="I0" />
            <blockpin signalname="x" name="I1" />
            <blockpin signalname="XLXN_2" name="O" />
        </block>
        <block symbolname="nand2" name="XLXI_4">
            <blockpin signalname="y" name="I0" />
            <blockpin signalname="XLXN_1" name="I1" />
            <blockpin signalname="XLXN_3" name="O" />
        </block>
        <block symbolname="nand2" name="XLXI_5">
            <blockpin signalname="XLXN_3" name="I0" />
            <blockpin signalname="XLXN_2" name="I1" />
            <blockpin signalname="XLXN_9" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1280" y="1008" name="XLXI_1" orien="R0" />
        <instance x="1696" y="880" name="XLXI_3" orien="R0" />
        <instance x="1696" y="1168" name="XLXI_4" orien="R0" />
        <instance x="2128" y="1008" name="XLXI_5" orien="R0" />
        <branch name="XLXN_1">
            <wire x2="1616" y1="912" y2="912" x1="1536" />
            <wire x2="1616" y1="912" y2="1040" x1="1616" />
            <wire x2="1696" y1="1040" y2="1040" x1="1616" />
            <wire x2="1616" y1="816" y2="912" x1="1616" />
            <wire x2="1696" y1="816" y2="816" x1="1616" />
        </branch>
        <branch name="XLXN_2">
            <wire x2="2032" y1="784" y2="784" x1="1952" />
            <wire x2="2032" y1="784" y2="880" x1="2032" />
            <wire x2="2128" y1="880" y2="880" x1="2032" />
        </branch>
        <branch name="XLXN_3">
            <wire x2="2032" y1="1072" y2="1072" x1="1952" />
            <wire x2="2032" y1="944" y2="1072" x1="2032" />
            <wire x2="2128" y1="944" y2="944" x1="2032" />
        </branch>
        <branch name="x">
            <wire x2="1120" y1="752" y2="752" x1="896" />
            <wire x2="1696" y1="752" y2="752" x1="1120" />
            <wire x2="1120" y1="752" y2="880" x1="1120" />
            <wire x2="1280" y1="880" y2="880" x1="1120" />
        </branch>
        <branch name="y">
            <wire x2="992" y1="1104" y2="1104" x1="880" />
            <wire x2="1120" y1="1104" y2="1104" x1="992" />
            <wire x2="1696" y1="1104" y2="1104" x1="1120" />
            <wire x2="1120" y1="944" y2="1104" x1="1120" />
            <wire x2="1184" y1="944" y2="944" x1="1120" />
            <wire x2="1248" y1="944" y2="944" x1="1184" />
            <wire x2="1280" y1="944" y2="944" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="896" y="752" name="x" orien="R180" />
        <branch name="XLXN_9">
            <wire x2="2416" y1="912" y2="912" x1="2384" />
        </branch>
        <iomarker fontsize="28" x="2416" y="912" name="XLXN_9" orien="R0" />
        <iomarker fontsize="28" x="880" y="1104" name="y" orien="R180" />
    </sheet>
</drawing>