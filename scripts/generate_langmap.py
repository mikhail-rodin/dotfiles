latin = 'QWERTYUIOPASDFGHJKLZXCVBNM<>qwertyuiopasdfghjklzxcvbnm,.'
cyrillic = 'ЙЦУКЕНГШЩЗФЫВАПРОЛДЯЧСМИТЬБЮйцукенгшщзфывапролдячсмитьбю'
res = 'vim.normalModeKeyBindings": ['
section = '\n\t{{\n\t\t\"before\": ["{}"],\n\t\t\"after\": ["{}"]\n\t}},'
for x in range(len(latin)):
    res = res + section.format(cyrillic[x], latin[x])
res += "\n],"
print(res)