# PyMol安装手册

命令行键入：python -m pip install pmw

进入网站https://www.lfd.uci.edu/~gohlke/pythonlibs/#pymol-open-source ，下载对应的pymol版本

命令行键入：python -m pip install xxx.whl

python -m pip install F:\【应用程序安装包】\pymol-2.5.0-cp39-cp39-win_amd64.whl

就好了

# PyMol操作手册

## 颜色设置

### 设置颜色名

set_color color_name, [a,b,c]

a,b,c为0~1的浮点数

```python
# 可以将255,255,255的数字读入，并输出为[1,1,1]的格式，直接输入到PyMol当中去
import pyperclip
import numpy as np
color =np.array(pyperclip.paste().strip().split(','))
print(color)
clipboard = str(list(color.astype(np.float)/255))
pyperclip.copy(clipboard)
print(clipboard)
```

### 设置对应选区的颜色

color color_name, select_region_name

### 设置不同二级结构的颜色

color set_color, ss h			alpha helix

color set_color, ss s			beta sheet

color set_color, ss l+''		loops & others

## 位点选择

select select_region_name, resi 5-20 in obj

