#!/bin/bash

# =============================================================================
# Tianracer Formula Mini 文档导出工具 (Marp to PDF) - Linux 版本
# =============================================================================
#
# 用途:
#   该脚本用于将 docs 文件夹下的 Markdown 文件导出为 PDF 格式。
#   支持导出全部文档或指定单个文档。
#
# 使用方法:
#   ./export_docs.sh                          # 导出所有文档
#   ./export_docs.sh 4.linux_ros_basic.md     # 导出指定文档
#   ./export_docs.sh -f 4.linux_ros_basic.md  # 使用 -f 参数指定文档
#
# =============================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOCS_PATH="./docs"
OUTPUT_PATH="./export_pdf"

# 打印帮助信息
show_help() {
    echo "用法: $0 [选项] [文件名]"
    echo ""
    echo "选项:"
    echo "  -f, --file FILE    指定要导出的文件名"
    echo "  -h, --help         显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                              # 导出所有文档"
    echo "  $0 4.linux_ros_basic.md         # 导出指定文档"
    echo "  $0 -f 4.linux_ros_basic.md      # 使用 -f 参数"
    echo ""
}

# 解析命令行参数
FILE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}[错误] 未知选项: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            FILE="$1"
            shift
            ;;
    esac
done

# 检查导出目录是否存在，不存在则创建
if [ ! -d "$OUTPUT_PATH" ]; then
    mkdir -p "$OUTPUT_PATH"
    echo -e "${GRAY}创建导出目录: $OUTPUT_PATH${NC}"
fi

# 检查是否安装了 npx
if ! command -v npx &> /dev/null; then
    echo -e "${RED}[错误] 未找到 Node.js/npx。${NC}"
    echo -e "${YELLOW}请运行以下命令安装 Node.js:${NC}"
    echo "  sudo apt update"
    echo "  sudo apt install nodejs npm"
    echo ""
    echo -e "${YELLOW}或访问 https://nodejs.org/ 下载最新版本${NC}"
    exit 1
fi

# 导出单个文件的函数
export_marp_file() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    local out_file="$OUTPUT_PATH/${file_name%.md}.pdf"
    
    echo "---"
    echo -e "${CYAN}正在转换: $file_name${NC}"
    
    # 使用 npx 运行 marp-cli
    # --allow-local-files 允许加载本地图片
    # --theme-set 指定主题目录，--theme 指定具体主题名
    if npx @marp-team/marp-cli@latest "$file_path" --pdf --allow-local-files --theme-set themes --theme tsinghuappt --html -o "$out_file" 2>&1; then
        echo -e "${GREEN}成功导出至: $out_file${NC}"
        return 0
    else
        echo -e "${RED}导出失败: $file_name${NC}"
        return 1
    fi
}

# 主逻辑
if [ -n "$FILE" ]; then
    # 导出指定文件
    # 如果文件名不包含 .md 扩展名，自动添加
    if [[ "$FILE" != *.md ]]; then
        FILE="${FILE}.md"
    fi
    
    TARGET_FILE="$DOCS_PATH/$FILE"
    
    if [ -f "$TARGET_FILE" ]; then
        export_marp_file "$TARGET_FILE"
    else
        echo -e "${RED}[错误] 找不到指定文件: $TARGET_FILE${NC}"
        exit 1
    fi
else
    # 导出所有文件
    echo -e "${YELLOW}=== 开始全量导出 Tianracer 教学文档 ===${NC}"
    
    count=0
    success=0
    
    # 遍历 docs 目录下的所有 .md 文件
    while IFS= read -r -d '' md_file; do
        file_name=$(basename "$md_file")
        
        # 过滤掉备份文件或 README
        if [[ "$file_name" == *copy* ]] || [[ "$file_name" == README* ]]; then
            continue
        fi
        
        if export_marp_file "$md_file"; then
            ((success++))
        fi
        ((count++))
    done < <(find "$DOCS_PATH" -maxdepth 1 -name "*.md" -type f -print0)
    
    echo ""
    echo -e "${YELLOW}=== 任务统计: 已处理 $count 个文档，成功 $success 个 ===${NC}"
fi

echo ""
echo -e "${GREEN}所有任务已结束。请在 $OUTPUT_PATH 文件夹中查看结果。${NC}"
