load("render.star", "render")
load("http.star", "http")
load("re.star", "re")
load("cache.star", "cache")
load("encoding/base64.star", "base64")

PHRASES = [
    "It's fineee",
    "Is it really tho?",
    "That's hella tight",
    "I'm gonna sleep in",
    "Umm I door dashed it",
    "I'm taking a short nap mmmkay?"
 ]

#Load images
#picture
JAYA_ICON2 = base64.decode("iVBORw0KGgoAAAANSUhEUgAAABcAAAAXCAYAAADgKtSgAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAF6ADAAQAAAABAAAAFwAAAACm59GpAAADpUlEQVRIDbWV3Y8TZRTGn+lMp53OtPR7txAVCkpQNELiRqO4wfgRsmziLYnEeKNX3kjCDSHBmKiJMfHWkPVCjZrohaJeqFkuVlFBFHbRBQRq2I922+72c9qZznRa3zmn/0LPxfSXk6fve+aZ855X+u30p0OIkIYBKFrERzSrVShBhbgnnpoeJl4oLOHx/D7itu3i/lyeWJE9mF1fCcTjMdg95gBlxvRQZKpbrC62aTRrtE0qmcSN2hrxe/NfQlK5huL6Xcwp/EaSJHLDAWniegxzr71JvFEuw6o3iKXr735Ny29ubSEWi1Hyi78W8O3Ni8Qdy4YCl7jV6SJsxIn1iA6z1STOpaLQ+yHiE8+9hAMP7ycery3FYpEr0SNwPfbom38uwBlwtZlUDKXSOmmyk2l0W/yxLNtCXNjnh6pp8D8wsRFGrbZJLF089TF3ixzAG5+9T8mObqBSLrBAkmAJa/zQVBWuLBHLnoxQlLtrZzYLz2UTpL6LD46dIM14bWl3u7RLUA+iLqr3o1oqQgZ3gmVZUIZcrTN0cHz2MGn6jgR34BC/PHMEb899Trxe78Cz+sRKJMRf+exPX2EYGCXFb71WJ8F24XlWdIYfRw5P4dz5X4kfnJpBcXmeuP/CNLZnJ4grhTKMKOvHa0tlq0I7Xin/B09iKxzHhviOFA/t2Yup3TuIH8jl8OI7bxFXK2VU8zPE4WgC+yf4D7eScTghPmjKRo0XD8gDtEyTxJporb0JnieFtdu4J8HimDZEqsQHLX3fHqzcWSH9rcUreOrpZ4mL5jyCUpB4vLYo4vD4YfUtZJMp4kajibbjEecnM/D6/MorG5swe0uUty78iUceO0i8dHURl65eIj72/FEMRmdBqdk8ZHodBx4sEriujWeeOET8x83LyElp4qihI72Nbfn+xt84MJun/KtnXsHZM68Tn/zwI0w/WiUery3NBlfuXw71xhZXGE/i3OVrxHZ7E7HRJZLQZHERGJQ/PnsU6irPnGJrHoeenKb8QqGO7xbPEytrjTWCttlDZiJLbPf7cG3unJASQmF1lfKSJ8Eb8HAz4pPYfXCK8iExc8wCa1zXEzcXWzdeW1weD1DVAYywTJV0m7aYhKOZo8rYNhoRpt3B78v/kub63VVcW+bOyWXS+OTHnymfyO2C44zGyCDAc9gUrbdL5sUjWhS2uHX8kAMq7t3B3VJr1ZCJ8itHxP1YEqfUj7kffoEuq8Sq1oKh8gEcqy3/A2gPVVGa30nVAAAAAElFTkSuQmCC")
#avatar
JAYA_ICON3 = base64.decode("iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAXZJREFUSEvNlq0OAjEMgHcPgQAH4iyKN8ASFBJHUAgUr0CCQqAIjicgJCjeAIVFgAPBQxzpwpberu16ByHM3HEt/fq3bon58UqUvEypF7UXVTDGZGkztbzL7UJyA7loUxJaEEDcU4qScIq0LQKVacypIed+AwT6G6oG5hrkftyYRndkwicYhm94gR6zPDz0wteNMqhNcQDOMQphp800g0bB3tcfNct61J8kk5IjaDkgGEuGfQvKtrsClJNXBrr6ARC/u1A5uRboaxg2hLZ+2JH3u5xSyNwnDUMA4RPbpbZUXwaKEfo9SKV0312Z3nHisxv+ZvakLqVclABxC8MjA0BOqZuHXJQlgfEI8elQtlvxlKEGOTVg/fkHkYRTR9oe4SylhjgJdBPfATGEipgb2qWB1AmvBaIDOV7D6frMZm7WOhVki2un8O0wH7griQycrs/RCxOGUjBMX47bnwPBIEBjMND7GlA7zP8PqPW8qp7mIlzVNvm/F7LJ0x29lys8AAAAAElFTkSuQmCC")

def main():

    index_cached = cache.get("array_index")
    if index_cached != None:
        print("Hit! Displaying cached data.")
        index = int(index_cached)
    else:
        print("Miss! Calling random.org API.")
        # Alt way to generate random number, learned from https://github.com/savetz/tidbyt-conways-game-of-life/blob/main/life-pretty.star
        resp = http.get("https://www.random.org/integers/?num=1&min=0&max=4&col=1&base=10&format=plain&rnd=new")
        if resp.status_code != 200:
            fail("Request failed with status %d", resp.status_code)
        random_index = resp.body()
        random_index = re.sub("\n", "", random_index)  #squish the numbers into a string of digits
        index = int(random_index)
        cache.set("array_index", str(int(index)), ttl_seconds=60)
    phrase = PHRASES[index]

    return render.Root(
        child=render.Box(
            child = render.Row(
                main_align="center",
                cross_align="center",
                expanded=True,
                children=[
                    render.Box(
                        color="#f3f6f4", #remove color background if picture is used
                        child=render.Image(src=JAYA_ICON3),
                        width=28,
                        height=28,
                    ),

                    render.Box(
                        child = render.Marquee(
                            height=16,
                            offset_start=6,
                            offset_end=6,
                            child=render.WrappedText(
                                content=phrase,
                                width=30,
                                # color="#f44336"
                            ),
                            scroll_direction="vertical",
                        ),
                       width=34,
                       height=32,
                        padding=2,
                    )

                ]
            )
        )
    )



