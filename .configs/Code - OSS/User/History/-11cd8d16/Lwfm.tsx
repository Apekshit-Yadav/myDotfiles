import { App } from "astal/gtk3";
import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

const time = Variable("").poll(1000, "date");

function Workspaces() {
    const hypr = Hyprland.get_default();
    return bind(hypr, "workspaces").as(wss => (
        <box className="Workspaces">
            {wss.filter(ws => ws.id < -99 || ws.id > -2)
                .sort((a, b) => a.id - b.id)
                .map(ws => (
                    <button
                        className={bind(hypr, "focusedWorkspace").as(fw => (ws === fw ? "focused" : ""))}
                        onClicked={() => ws.focus()}>
                        {ws.id}
                    </button>
                ))}
        </box>
    ));
}

function Time({ format = "%H:%M - %A %e." }) {
    const time = Variable("").poll(1000, () => GLib.DateTime.new_now_local().format(format)!);
    return <label className="Time" onDestroy={() => time.drop()} label={time()} />;
}

function FocusedClient() {
    const hypr = Hyprland.get_default();
    return bind(hypr, "focusedClient").as(client => (
        client && <box className="Focused"><label label={bind(client, "title").as(String)} /></box>
    ));
}

function SysTray() {
    const tray = Tray.get_default();
    return bind(tray, "items").as(items => (
        <box className="SysTray">
            {items.map(item => (
                <menubutton
                    tooltipMarkup={bind(item, "tooltipMarkup")}
                    usePopover={false}
                    actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                    menuModel={bind(item, "menuModel")}
                >
                    <icon gicon={bind(item, "gicon")} />
                </menubutton>
            ))}
        </box>
    ));
}

function Wifi() {
    return bind(Network.get_default(), "wifi").as(wifi => (
        wifi && <icon tooltipText={bind(wifi, "ssid").as(String)} className="Wifi" icon={bind(wifi, "iconName")} />
    ));
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!;
    return (
        <box className="AudioSlider" css="min-width: 140px">
            <icon icon={bind(speaker, "volumeIcon")} />
            <slider hexpand onDragged={({ value }) => (speaker.volume = value)} value={bind(speaker, "volume")} />
        </box>
    );
}

function BatteryLevel() {
    return bind(Battery.get_default(), "isPresent").as(present => (
        present && (
            <box className="Battery">
                <icon icon={bind(Battery.get_default(), "batteryIconName")} />
                <label label={bind(Battery.get_default(), "percentage").as(p => `${Math.floor(p * 100)} %`)} />
            </box>
        )
    ));
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
    return (
        <window
            className="Bar"
            gdkmonitor={gdkmonitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={BOTTOM | LEFT | RIGHT}
            application={App}>
            <centerbox>
                <box className="leftbox">
                    <button className="archbtn" onClicked="sh -c '/home/papa/HyprlandScripts/launcher.sh || (killall rofi)'" halign={Gtk.Align.LEFT}>
                        󰣇
                    </button>
                    <Workspaces />
                    <FocusedClient />
                </box>
                <box className="midbox">
                    <Time />
                </box>
                <box className="rightbox" hexpand halign={Gtk.Align.END}>
                    <SysTray />
                    <Wifi />
                    <AudioSlider />
                    <BatteryLevel />
                </box>
            </centerbox>
        </window>
    );
}
