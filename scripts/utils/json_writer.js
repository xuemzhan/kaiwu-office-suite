// KaiWu V1.4.1 JSON writer. Windows Script Host / Windows 7 compatible.
(function () {
    var args = WScript.Arguments;
    if (args.length < 3) WScript.Quit(1);
    var mode = String(args(0));
    var output = String(args(1));
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var shell = new ActiveXObject("WScript.Shell");
    function q(v) {
        return '"' + String(v == null ? "" : v)
            .replace(/\\/g, "\\\\").replace(/"/g, '\\"')
            .replace(/\r/g, "\\r").replace(/\n/g, "\\n") + '"';
    }
    function env(name) { return shell.ExpandEnvironmentStrings("%" + name + "%"); }
    function writeUtf8(path, text) {
        var stream = new ActiveXObject("ADODB.Stream");
        stream.Type = 2;
        stream.Charset = "utf-8";
        stream.Open();
        stream.WriteText(text);
        stream.SaveToFile(path, 2);
        stream.Close();
    }
    var now = new Date();
    var stamp = now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate() + " " + now.toLocaleTimeString();
    var json;
    if (mode === "context") {
        var type = String(args(2));
        json = '{"context_info":{"type":' + q(type) + ',"timestamp":' + q(stamp) +
            ',"computer_name":' + q(env("COMPUTERNAME")) + ',"username":' + q(env("USERNAME")) +
            ',"user_domain":' + q(env("USERDOMAIN")) + '},"system_info":{"os_version":' +
            q(shell.ExpandEnvironmentStrings("%OS%")) + ',"architecture":' + q(env("PROCESSOR_ARCHITECTURE")) +
            ',"processor_count":' + q(env("NUMBER_OF_PROCESSORS")) + ',"temp_folder":' + q(env("TEMP")) +
            ',"system_root":' + q(env("SYSTEMROOT")) + '},"config_info":{"suite_version":"1.4.1"}}';
    } else if (mode === "search" && args.length >= 5) {
        var source = String(args(2)), keyword = String(args(3)), searchPath = String(args(4));
        var rows = [], file, line;
        if (fso.FileExists(source)) {
            file = fso.OpenTextFile(source, 1, false, -2);
            while (!file.AtEndOfStream) {
                line = file.ReadLine();
                if (line) rows.push('{"path":' + q(line) + '}');
            }
            file.Close();
        }
        json = '{"search_info":{"keyword":' + q(keyword) + ',"path":' + q(searchPath) +
            ',"timestamp":' + q(stamp) + ',"result_count":' + rows.length + '},"results":[' + rows.join(',') + ']}';
    } else {
        WScript.Quit(1);
    }
    writeUtf8(output, json);
    WScript.Quit(0);
}());