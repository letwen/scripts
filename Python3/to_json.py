def tf_json(j_name,info,dsp="no") :
    import os
    import json
    path=os.path.abspath(os.path.curdir)
    j_path=path+"\\json"
    j_file=j_path+f"\\{j_name}"
    if os.path.isdir(j_path) :
        print("json folder already exists")
    else :
        try :
            os.makedirs(j_path)
        except :
            return 'failed to create json folder'
        else :
            print("successful creation of json folder")
    try :
        j_file_open=open(j_file,mode='w+',encoding="utf-8")
        json.dump(info,j_file_open,ensure_ascii=False)
    except :
        return 'Error, failed to create or write file'
    else :
        print("Write file successfully")
    finally :
        j_file_open.close()
        if dsp == "yes" :
            return json.dumps(info,ensure_ascii=False)
        else :
            return 'no display'
