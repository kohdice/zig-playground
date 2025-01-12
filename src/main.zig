const std = @import("std");

pub fn main() !void {
    // 標準エラー出力に出力します（`std.io.getStdErr()` に基づくショートカットです）
    std.debug.print("全ての {s} は我々のものだ。\n", .{"codebase"});

    // 標準出力はアプリケーションの実際の出力用です。例えば、gzip を実装している場合、
    // 圧縮されたバイトデータだけを標準出力に送るべきであり、デバッグメッセージは出力しません。
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("テストを実行するには `zig build test` を実行してください。\n", .{});

    try bw.flush(); // 忘れずに flush しましょう！
}

test "簡単なテスト" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // この行をコメントアウトして、Zig がメモリリークを検出するか確認してみてください！
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
