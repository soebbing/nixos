// TLP Power Profile — a GNOME Shell Quick Settings tile that toggles TLP
// between the AC and battery profile via `pkexec /etc/tlp-set ac|bat`.
//
// The polkit rule that authorises /etc/tlp-set for the active local user lives
// in modules/desktop/manager/gnome.nix.

import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import Gio from 'gi://Gio';

const TLP_SET = '/etc/tlp-set';
const AC_PATHS = [
    '/sys/class/power_supply/AC/online',
    '/sys/class/power_supply/AC0/online',
];

function readAcOnline() {
    for (const path of AC_PATHS) {
        try {
            const [ok, bytes] = GLib.file_get_contents(path);
            if (!ok) continue;
            const v = String(bytes).trim();
            if (v === '1') return true;
            if (v === '0') return false;
        } catch (_e) {
            // try the next path
        }
    }
    return null;
}

function setProfile(profile) {
    try {
        return Gio.Subprocess.new(
            ['pkexec', TLP_SET, profile],
            Gio.SubprocessFlags.NONE,
        );
    } catch (_e) {
        return null;
    }
}

const TlpPowerToggle = GObject.registerClass(
class TlpPowerToggle extends QuickSettings.QuickToggle {
    _init() {
        super._init({
            title: 'Power profile',
            iconName: 'battery-symbolic',
            toggleMode: true,
        });
        this._refresh();
        this.connect('clicked', () => this._onClicked());
    }

    _refresh() {
        const onAc = readAcOnline();
        if (onAc === null) {
            this.subtitle = 'TLP unavailable';
            this.set({checked: false, iconName: 'dialog-warning-symbolic'});
            return;
        }
        // "checked" reflects the currently applied AC profile.
        this.set({
            checked: onAc,
            iconName: onAc ? 'ac-adapter-symbolic' : 'battery-symbolic',
        });
        this.subtitle = onAc ? 'AC profile' : 'Battery profile';
    }

    _onClicked() {
        const target = this.checked ? 'ac' : 'bat';

        // Revert the optimistic toggle until pkexec lands; _refresh() will
        // re-sync from sysfs once the subprocess finishes.
        this.set({checked: !this.checked});
        this.subtitle = target === 'ac' ? 'Switching to AC…' : 'Switching to battery…';

        const proc = setProfile(target);
        if (proc === null) {
            this._refresh();
            return;
        }
        proc.wait_async(null, (_p, res) => {
            try {
                proc.wait_finish(res);
            } catch (_e) {
                // pkexec rejected (no polkit authorisation, etc.) — fall back.
            }
            this._refresh();
        });
    }
});

export default class TlpPowerExtension extends Extension {
    enable() {
        this._indicator = new QuickSettings.SystemIndicator();
        this._toggle = new TlpPowerToggle();
        this._indicator.quickSettingsItems.push(this._toggle);
        Main.panel.statusArea.quickSettings._indicators.add_child(this._indicator);
        Main.panel.statusArea.quickSettings._addItems([this._toggle]);
    }

    disable() {
        this._toggle?.destroy();
        this._indicator?.destroy();
        this._toggle = null;
        this._indicator = null;
    }
}
