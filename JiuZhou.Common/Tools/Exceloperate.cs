using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using Aspose.Cells;

namespace JiuZhou.Common.Tools
{
    public class Exceloperate
    {
        #region 把对象List保存到Excel
        /// <summary>
        /// 把对象List保存到Excel
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <param name="saveFilePath"></param>
        public static Worksheet SetExcelList<T>(List<T> objList, Worksheet sheet)
        {
            // 冻结第一行    
            sheet.FreezePanes(1, 1, 1, 0);
            // 循环插入每行    
            int row = 0;
            foreach (var obj in objList)
            {
                int column = 0;
                var properties = obj.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.IgnoreCase | BindingFlags.DeclaredOnly);
                if (row == 0)
                {
                    foreach (var titName in properties)
                    {
                        sheet.Cells[0, column].PutValue(titName.Name);
                        sheet.Cells.SetRowHeight(0, 30);
                        Style style = sheet.Cells[0, column].GetStyle();
                        style.ForegroundColor = System.Drawing.Color.FromArgb(128, 128, 128);
                        style.Pattern = BackgroundType.Solid;
                        style.Font.Color = System.Drawing.Color.White;
                        sheet.Cells[0, column].SetStyle(style);
                        column++;

                    }
                    row++;
                }
                // 循环插入当前行的每列
                column = 0;
                foreach (var property in properties)
                {
                    var itemValue = property.GetValue(obj, null);
                    if (property.PropertyType == typeof(decimal) || property.PropertyType == typeof(int))
                    {
                        sheet.Cells[row, column].PutValue(itemValue.ToString(), true);
                        Style style = sheet.Cells[row, column].GetStyle();
                        //设置cell大小 设置背景颜色 最后增加一行总结
                        //保单号 药品明细清单
                        style.Number = 0;
                        sheet.Cells[row, column].SetStyle(style);
                        if (itemValue.ToString() == "0")
                        {
                            sheet.Cells[row, column].PutValue("");
                        }
                    }
                    else
                    {
                        sheet.Cells[row, column].PutValue(itemValue.ToString());
                    }
                    column++;
                }
                row++;
            }
            return sheet;
        }
        #endregion
    }
}
