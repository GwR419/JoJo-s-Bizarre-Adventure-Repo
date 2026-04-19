import re
import os

def fix_transcript_files(directory_path):
    
    pattern = r'^([a-z])([^:]*):'

  
    def capitalize(match):
        return f"{match.group(1).upper()}{match.group(2)}:"

   
    extensions = ('.txt')

    for filename in os.listdir(directory_path):
        if filename.endswith(extensions):
            file_path = os.path.join(directory_path, filename)
            
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

           
            fixed_content = re.sub(pattern, capitalize, content, flags=re.MULTILINE)

            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(fixed_content)
            
            print(f"Fixed speakers in: {filename}")


folder_to_process = "./jojoEpisodes/04" 

if __name__ == "__main__":
    if os.path.exists(folder_to_process):
        fix_transcript_files(folder_to_process)
    else:
        print(f"Error: Folder '{folder_to_process}' not found.")