const std = @import("std");

// この関数は命令的に見えますが、その役割はビルドグラフを宣言的に構築することであり、
// そのビルドグラフは外部の実行環境によって実行されます。
pub fn build(b: *std.Build) void {
    // 標準的なターゲットオプションを使うことで、`zig build` を実行する人が
    // どのターゲット用にビルドするかを選択できます。ここではデフォルト設定を
    // 上書きせず、デフォルトは「ネイティブ環境」となります。
    // 対応するターゲットを制限する方法もあります。
    const target = b.standardTargetOptions(.{});

    // 標準的な最適化オプションを使うことで、`zig build` 実行時に
    // Debug、ReleaseSafe、ReleaseFast、ReleaseSmall から最適化モードを選択できます。
    // ここでは特定のリリースモードを指定せず、ユーザーに最適化方法を任せています。
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "hello-zig-cli",
        // この場合、メインのソースファイルは単なるパスですが、
        // より複雑なビルドスクリプトでは生成されたファイルを指定することもあります。
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // ユーザーが `zig build` の "install" ステップを実行したときに、
    // ライブラリが標準のインストール場所に配置されることを宣言しています。
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "hello-zig-cli",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // ユーザーが `zig build` の "install" ステップを実行したときに、
    // 実行ファイルが標準のインストール場所に配置されることを宣言しています。
    b.installArtifact(exe);

    // ビルドグラフ内に "Run" ステップを作成します。このステップは他の依存するステップが
    // 評価されたときに実行されます。次の行でこの依存関係を設定します。
    const run_cmd = b.addRunArtifact(exe);

    // "Run" ステップを "install" ステップに依存させることで、実行時にキャッシュディレクトリ
    // ではなくインストールディレクトリから実行されます。
    // これは必須ではありませんが、アプリケーションが他のインストール済みファイルに依存する場合、
    // それらが正しい場所に存在することを保証します。
    run_cmd.step.dependOn(b.getInstallStep());

    // ユーザーがビルドコマンド内で引数を渡せるようにします。
    // 例: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // ビルドステップを作成します。このステップは `zig build --help` メニューで表示され、
    // `zig build run` で選択できます。このコマンドを実行すると、
    // デフォルトの "install" ではなく "run" ステップが評価されます。
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // ユニットテスト用のステップを作成します。これはテスト用実行ファイルをビルドするだけで、
    // 実行はしません。
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // 先ほど "run" ステップを作成したのと同様に、`zig build --help` メニューに `test` ステップを追加し、
    // ユーザーがユニットテストを実行できるようにします。
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
