from flask import stream_with_context, request
from flask import Flask, Response
import time


app = Flask(__name__)


@app.route("/index")
def index():
    return """
        <p>Hello, World!</p>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            function call_stream() {
                console.log("Calling");
                var last_response_len = false;
                $.ajax({
                    url: "/stream",
                    success: function(result) {
                        console.log("total: " + result);
                    },
                    xhrFields: {
                        onprogress: function(e)
                        {
                            console.log("received: " + e.currentTarget.response)
                            var this_response, response = e.currentTarget.response;
                            if(last_response_len === false)
                            {
                                this_response = response;
                                last_response_len = response.length;
                            }
                            else
                            {
                                this_response = response.substring(last_response_len);
                                last_response_len = response.length;
                            }
                            console.log("increment: " + this_response);
                        }
                    }
                })
            }
            $(document).ready(function() {
                call_stream();
            })
        </script>
    """


@app.route('/stream')
def streamed_response():
    def generate():
        yield 'First Name: Quentin\n'
        time.sleep(1)
        yield 'Last Name: Duval\n'
        time.sleep(1)
        yield 'Age: N/A\n'
    return app.response_class(generate(), mimetype='text/event-stream')


if __name__ == "__main__":
    app.run()
