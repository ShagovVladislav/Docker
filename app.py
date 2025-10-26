from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/calculate', methods=['POST'])
def calculate():
    try:
        protein = float(request.form['protein'])
        fat = float(request.form['fat'])
        carb = float(request.form['carb'])
    except (KeyError, ValueError):
        return render_template('index.html', error="Введите корректные значения БЖУ.")

    calories = protein * 4 + fat * 9 + carb * 4

    return render_template('index.html', 
                           protein=protein, 
                           fat=fat, 
                           carb=carb, 
                           calories=calories)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
