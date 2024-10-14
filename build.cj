import std.os.{getArgs, currentDir}
import std.fs.{Path, Directory}

func stagePostBuild(): Int64{
    // 将config目录下的文件复制到打包目录中
    let source = Path("./config")
    let target = Path("./target/release/bin/config")
    Directory.copy(source, target, true)
    return 0
}

main(): Int64{
    match(getArgs()[0]){
        // Add operation here with format: "pre-"/"post-" + optionName
        // case "pre-build" => stagePreBuild()
        case "post-build" => stagePostBuild()
        // case "pre-clean" => stagePreClean()
        // case "post-clean" => stagePostClean()
        case _ => return 0
    }
}